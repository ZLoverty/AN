clear all
close all
clc
%%
% Load Video
name='0912lambda200h50' %name of the video
fname=['tif' filesep name '.tif']; %path of the movie
info=imfinfo(fname);
Ni=numel(info); %number of frame in the video
scale=info.XResolution; %pixels/um


N=Ni;
Folder=['Results' filesep name]; %path to save the detection results
mkdir(Folder)

I=imread(fname,1);
imshow(I)
% Find Mask
m=1;
if m==1

fnameM=['tif' filesep name '_Mask.tif']; %path of the mask
infoM=imfinfo(fnameM);
thres=0.7;
Mask=imread(fnameM,1);
Mask=Mask>thres; %transform into logicals
figure(1)
imshowpair(Mask, imread(fname,1))
end

if m==0
    exampleMask=zeros(size(imread(fname,1)));
end

%%
fname = "C:\Users\zl948\Documents\AN\kymo\08_A-2100.tif";

%% Screen Parameters %% to adjust the computation parameters
close all
screen=1;
if screen==1
%screening(fname,exampleMask,'sigma2',30,'m',m);
screening(fname,Mask,'m',m);
end


%% Snapshot to optimize parameters 
close all
sn=1;
sigma1=1;
sigma2=7;
sz=11;
th=0.1;

if sn==1
    snap(fname,fnameM,sigma1,sigma2,sz,th,4);
end

%% Define Parameters
sigma1=1;
sigma2=5;
sz=10;
th=0.1;

%% Prepare Treatment folder
Treatment=[Folder filesep 'Treatment'];
mkdir(Treatment);
% get structure tensor orientation, n, and S for the stack of frames
I= imread(fname,1,'Info', info);


[Nx Ny]=size(I)
ex_Max_Int=zeros(Nx,Ny,N);

for ni=1:N
    disp(['Storing image......' num2str(ni)]);
    ex_Max_Int(:,:,ni)=imread(fname,ni,'Info', info);
end
save([Treatment filesep 'ex_Max_Int.mat'],'ex_Max_Int');
imshow(I)

%% Compute Director Field
%preallocate arrays
stStack = zeros(size(ex_Max_Int));
DirStack = zeros(size(ex_Max_Int));
SStack = zeros(size(ex_Max_Int));

for tt = 1:Ni
    st = fndstruct(sigma1, sigma2, ex_Max_Int(:,:,tt)); %find structure tensor 
    [SS, NN] = qTensor(st, sz); 

    % place the quantities in the arrays
    stStack(:,:,tt) = st;
    DirStack(:,:,tt) = NN; %eigen vector/ ngle of the director field n
    SStack(:,:,tt) = SS;%eigenvalue/order parameter
    clc
    disp(['Computing Director Field for frame......' num2str(tt) '/' num2str(size(ex_Max_Int, 3))]);
end

%% find the defects

posCell = cell([1,size(DirStack,3)]); %cell to hold the defects found in each frame
negCell = cell([1,size(DirStack,3)]);

for tt = 1:Ni
    disp(['Analyzing frame.......' num2str(tt)]);
    [pos, neg] = dftfnd2(SStack(:,:,tt),DirStack(:,:,tt),Mask,th);
    posCell{tt} = pos;
    negCell{tt} = neg;
end
save([Treatment filesep 'posCell.mat'],'posCell');
save([Treatment filesep 'negCell.mat'],'negCell');


%% Track the Defects
posStack = [];
negStack = [];
for tt = 1:size(ex_Max_Int, 3)
    tempPos = posCell{tt};
    tempNeg = negCell{tt};
    toAddPos = [tempPos,tt*ones([size(tempPos,1),1])];
    toAddNeg = [tempNeg,tt*ones([size(tempNeg,1),1])];
    posStack = [posStack;toAddPos];
    negStack = [negStack;toAddNeg];
end
% set parameters for track function, see track function for more info
params = struct('mem',6,'dim',2,'good',1,'quiet',0);
%params = struct(6,0,2,2,5,1,1,0)
search = 30;

if ~isempty(posStack)
    if length(unique(posStack(:,3)))==1
        posTracks=posStack;
    else
        posTracks = track(posStack,search,params);
    end
else
    posTracks=posStack;
end

if ~isempty(negStack)
    if length(unique(negStack(:,3)))==1
        negTracks=negStack;
    else
        negTracks = track(negStack,search,params);
    end
else
    negTracks=negStack;
end

save([Treatment filesep 'posTracks.mat'],'posTracks');
save([Treatment filesep 'negTracks.mat'],'negTracks');

%% Compute Angles of the positive +1/2 defects
rect=[5 5 Ny-10 Nx-10];
s=1;

[DefDir]=directionst(DirStack,posCell,negCell,rect,s);
save([Treatment filesep 'DefDir.mat'],'DefDir');

%% Save DirStack
Folder=[Treatment filesep 'DirStack'];
mkdir(Folder);
Folder2=[Treatment filesep 'qStack'];
mkdir(Folder2);

for ni=1:N
    Dir=DirStack(:,:,ni);
    savename=[Folder filesep 'Dir_' num2str(ni) '.mat'];
    save(savename,'Dir');
    clc
    disp(['Saving Director Field for frame......' num2str(ni)])
end

%% Plot Director field (DirStack) and defects
ni=1; %frame on which to plot

ux=cos(DirStack);
uy=sin(DirStack); 

IM=imread(fname,ni);
[xS,yS] = meshgrid(1:20:size(DirStack(:,:,ni),2), 1:20:size(DirStack(:,:,ni),1));
toplot_big = DirStack(:,:,ni)*pi;
pdefinds = sub2ind(size(DirStack(:,:,ni)), fliplr(posCell{ni})); %recall defect output is in x,y and indices are in r,c
ndefinds = sub2ind(size(DirStack(:,:,ni)), fliplr(negCell{ni}));
toplot_big(pdefinds) = NaN; 
toplot_big(ndefinds) = NaN;
toplot = interp2(toplot_big,xS,yS, 'nearest');
Maskplot=double(interp2(Mask,xS,yS,'nearest'));  
    
h=figure()
im = imread(fname, ni, 'Info', info);
imshow(im)
hold on; %enable plotting overwrite
     q=quiver(xS,yS,Maskplot.*cos(toplot), Maskplot.*sin(toplot),'k', ...
         'ShowArrowHead', 'off', 'AutoScaleFactor', 0.3,'Color','k', 'LineWidth', 2)
     q.Color='white';

     hold on
     r=quiver(xS,yS,-Maskplot.*cos(toplot), -Maskplot.*sin(toplot),'k', ...
         'ShowArrowHead', 'off', 'AutoScaleFactor', 0.3,'Color','k', 'LineWidth', 2)
     r.Color='white';
if ~isempty(posCell{ni})
    plot(posCell{ni}(:,1), posCell{ni}(:,2),'ro','MarkerSize',10, 'MarkerFaceColor', 'r')
end
Positive=DefDir{1,ni};
angle=Positive(:,3);
xpos=Positive(:,1);
ypos=Positive(:,2);
f=10;
for comet=1:size(angle,1)
    quiver(xpos(comet),ypos(comet),5*f*cos(angle(comet)), 5*f*sin(angle(comet)),'Color', 'red','LineWidth',4., 'ShowArrowHead', ...
        'off','AutoScale','off')
end

