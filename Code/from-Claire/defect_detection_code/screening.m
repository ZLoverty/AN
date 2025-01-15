function []=screening(fname,exampleMask,varargin)
variables={'sigma1','sigma2','sz','th','m'};
screens={1:1:5;3:2:30;1:5:20;0.1;1};
if ~isempty(varargin)
    Nvar=numel(varargin)/2;
    for j=1:Nvar
       var=varargin{2*j-1}; 
       ind=find(strcmp(var,variables))
       screens{ind}=varargin{2*j};
    end
end


%% Opens image stacks, draws mask and save in .mat

[filedir name ext]=fileparts(fname);
% fname='E:\ExperimentalData\torus_inclusions\center.tif'
info = imfinfo(fname);
Ni = numel(info);
% Ni=10;
I= imread(fname, 1, 'Info', info);
% imagesc(I)
[Nx Ny]=size(I)
ex_Max_Int=zeros(Nx,Ny,1);


for ni=1
    ex_Max_Int(:,:,ni)=imread(fname,ni,'Info', info);
    %       ex_Max_Int(:,:,ni)=zeros(Nx,Ny);
end

m=screens{5};
if m==0
exampleMask=ones(Nx,Ny);
else
% [Maskname, PathMask]=uigetfile('E:\ExperimentalData\torus_inclusions\Treated\*.tif')
% fnameM=[PathMask,Maskname];
% infoM = imfinfo(fname);
% thres=0.7;
% Mask=imread(fnameM,1);
% Mask=Mask>thres;
% exampleMask=Mask;
end


%% display some images
% disp(['the size in [px x px x frames] of the intensity array is: ' num2str(size(ex_Max_Int))])
% figure(1)
% imshow(ex_Max_Int(:,:,1),[])
% title('Frame 1')
% figure(2)
% imshow(ex_Max_Int(:,:,Ni),[])
% title('Frame 10')
%% look at the mask on its own and in comparison to a frame
% the mask was calculated by summing the full timeseries or the active
% nematic and then thresholding the summed image.
%
% figure(3)
% imshow(exampleMask)
% title('mask telling us where to look for data')
%
figure(1)
imshowpair(exampleMask, ex_Max_Int(:,:,1))
title('mask overlaid on frame 1')
% notice how the mask is still a bit big. Let's make is smaller

%% shrink the mask by successively removing the outermost layer of pixels
winnow = 0;
mask_toUse = exampleMask;
% for ii = 1:winnow
%     %bwperim gets the indices of the boundary of a white region in a binary
%     %image
%    mask_toUse(bwperim(mask_toUse)) = 0; %set the boundary to 0
% end
% figure(2)
% imshowpair(mask_toUse, ex_Max_Int(:,:,1))
% title('shrunken mask overlaid on frame 1')

% figure(3)
% imshowpair(mask_toUse, exampleMask)
% title('shrunken mask overlaid on the original mask')

%% get structure tensor orientation, n, and S for the stack of frames
%preallocate arrays
stStack = zeros(size(ex_Max_Int));
DirStack = zeros(size(ex_Max_Int));
SStack = zeros(size(ex_Max_Int));

newdir=filedir + filesep + name + filesep + 'screening';
mkdir(newdir)

fou=0;
for sigma1=screens{1}
    for sigma2=screens{2}
        for sz=screens{3}
            for th=screens{4}
                fou=fou+1;
                if fou>10000
                    return
                else
                    % h=figure(1)
                    for tt = 1:size(ex_Max_Int, 3)
                        % for tt = 1:size(ex_Max_Int, 3)
                        %     'Computing S'
                        %     tt
                        % for tt = 1:50
                        % calculate the st, S, n using parameters from above
                        st = fndstruct(sigma1, sigma2, ex_Max_Int(:,:,tt));
                        [SS, NN] = qTensor(st, sz);
                        
                        % place the quantities in the arrays
                        stStack(:,:,tt) = st;
                        DirStack(:,:,tt) = NN;
                        SStack(:,:,tt) = SS;
                    end
                    %% look at some examples
                    % figure(1)
                    % imshow(stStack(:,:,1))
                    % title('structure tensor for frame 1')
                    % figure(2)
                    % imshow(SStack(:,:,1))
                    % title('Scalar order parameter for frame 1')
                    % figure(3)
                    % imshow(DirStack(:,:,1))
                    % title('Director for frame 1 [b,w] correspond to [0,pi] measured off of the horizontal')
                    % note how the algorithm calculate st, n, S for the entire image. this is
                    % why we need a mask so that we know the region we're actually interested
                    % in
                    
                    %also rememeber that in an image, the origin is the top left corner and
                    %positive y is DOWN. Thus, the orientations as displayed are measured CW
                    %off of the horizontal!
                    
                    %% find the defects
                    %    th = 0.02; %threshold on S to consider a point a potential defect
                    
                    posCell = cell([1,size(DirStack,3)]); %cell to hold the defects found in each frame
                    negCell = cell([1,size(DirStack,3)]);
                    
                    for tt = 1:size(ex_Max_Int, 3)
                        [pos, neg] = dftfnd2(SStack(:,:,tt),DirStack(:,:,tt),mask_toUse,th)
                        posCell{tt} = pos;
                        negCell{tt} = neg;
                    end
                    'done'
                    
                    % %get the director to plot, dowsample, and set defect locations to NaN
                    % [xS,yS] = meshgrid(linspace(1,size(DirStack(:,:,1),2), 50), linspace(1,size(DirStack(:,:,1),1),50));
                    % toplot_big = DirStack(:,:,1)*pi;
                    % pdefinds = sub2ind(size(DirStack(:,:,1)), fliplr(posCell{1})); %recall defect output is in x,y and indices are in r,c
                    % ndefinds = sub2ind(size(DirStack(:,:,1)), fliplr(negCell{1}));
                    % toplot_big(pdefinds) = NaN; toplot_big(ndefinds) = NaN;
                    % toplot = interp2(toplot_big,xS,yS, 'nearest');
                    
                    % this step can be easily folded into the loop used to find the director.
                    % it's separated here for clarity purposes
                    %% look at the defects for a single frame
                    % h=figure(1)
                    
                    for ni=1:size(ex_Max_Int, 3)
                        %get the director to plot, dowsample, and set defect locations to NaN
                        [xS,yS] = meshgrid(linspace(1,size(DirStack(:,:,ni),2),80), linspace(1,size(DirStack(:,:,ni),1),80));
                        toplot_big = DirStack(:,:,ni)*pi;
                        pdefinds = sub2ind(size(DirStack(:,:,ni)), fliplr(posCell{ni})); %recall defect output is in x,y and indices are in r,c
                        ndefinds = sub2ind(size(DirStack(:,:,ni)), fliplr(negCell{ni}));
                        toplot_big(pdefinds) = NaN; toplot_big(ndefinds) = NaN;
                        toplot = interp2(toplot_big,xS,yS, 'nearest');
                        
                        
                        h=figure(1)
                        im = imread(fname, 1, 'Info', info);
                        imshow(im)
                        hold on; %enable plotting overwrite
%                         q=quiver(xS,yS,cos(toplot), sin(toplot),'k', ...
%                             'ShowArrowHead', 'off', 'AutoScaleFactor', 0.2,'Color','k')
%                         q.Color='white';
%                         hold on
%                         r=quiver(xS,yS,-cos(toplot), -sin(toplot),'k', ...
%                             'ShowArrowHead', 'off', 'AutoScaleFactor', 0.2,'Color','k')
                        if ~isempty(posCell{ni})
                            plot(posCell{ni}(:,1), posCell{ni}(:,2),'r^','MarkerSize',2)
                        end
                        if ~isempty(negCell{ni})
                            plot(negCell{ni}(:,1), negCell{ni}(:,2),'b*','MarkerSize',2)
                        end
                        iptsetpref('ImshowBorder','tight');
                        % quiver(x,y,px,py) %plot the quiver on top of the image (same axis limits)
                        F=getframe(h);
                        [X Map]=frame2im(F);
                        imagesc(X)
                    end
                                    

                    s=strsplit(num2str(sz),'.')
                    ssz=[];
                    for i=1:numel(s)
                        ssz=[ssz s{i}]
                    end
                    
                    s=strsplit(num2str(th),'.')
                    tth=[];
                    for i=1:numel(s)
                        tth=[tth s{i}]
                    end
                    %
                    
                    savename = newdir + filesep + name + '_' + 's1_' + num2str(sigma1) + '_s2_' + num2str(sigma2) + '_sz_' + ssz + '_th_' + tth + '.tif'
                     imwrite(X,savename)
                    % savename=[filedir filesep name];
%                     print(h,savename,'-dpng')
                    
                    
                    % h.PaperUnits = 'inches';
                    % h.PaperPosition =a [3 3 3 3];
                    % print(savename,'-dpng','-r0')
                    % print('-bestfit',savename,'-dpdf')
                end
            end
        end
    end
end
end
