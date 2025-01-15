clear all
close all

%% Find PIV files
Folder='PIV_results';
Alis=dir([Folder filesep '*B']);

numb=size(Alis,1);

for M=1:numb
    movie=Alis(M).name;
    files=dir([Folder filesep movie filesep '*.txt']);
    name=movie(5:end);


    N=numel(files);

    fname=[files(1).folder filesep files(1).name]
    T=readtable(fname);
    
    xi=unique(T{:,1});
    nx=numel(xi);
    Nx=nx
    yi=unique(T{:,2});
    ny=numel(yi);
    Ny=ny
    
    
   dx=xi(2)-xi(1);
    
   X=(reshape(T{:,1},nx,ny))';
   Y=(reshape(T{:,2},nx,ny))';
    




    
% Allocate subwindows X, Y, H

%Window X
x1=70;
x2=225;
y1=0;
y2=1500;
    
[row_wX,col_wX]=find(X>=x1 & X<=x2 & Y>=y1 & Y<=y2);
X_sub=X(min(row_wX):max(row_wX), min(col_wX):max(col_wX));
Y_sub=Y(min(row_wX):max(row_wX), min(col_wX):max(col_wX));
[ny_wX,nx_wX]=size(X_sub);
    
Vx_wX=zeros(ny_wX,nx_wX,N);
Vy_wX=zeros(ny_wX,nx_wX,N);

filename1=[name '_Y_sub.mat'];
save(filename1, 'Y_sub');
filename2=[name '_X_sub.mat'];
save(filename2, 'X_sub');
 
%
l_errors=[0;0];
for n=1:N
    hop=n
   
    fname=[files(n).folder filesep files(n).name];
    T=readtable(fname);
    [X,Y]=meshgrid(xi,yi);
    ux=T{:,3};
    uy=T{:,4};
    if length(ux)==nx*ny
        ux=reshape(ux,nx,ny);
        uy=reshape(uy,nx,ny);
        nor=reshape(T{:,5},nx,ny);
        Vx=ux';
        Vy=uy';
        norm=nor';
        
        %Window X
        Vx_wX(:,:,n)=Vx(min(row_wX):max(row_wX), min(col_wX):max(col_wX));
        Vy_wX(:,:,n)=Vy(min(row_wX):max(row_wX), min(col_wX):max(col_wX));
        clear Vy
        clear Vx
        
    
    else
        l_errors=[l_errors, [hop;length(ux)]];
    end
    
    clear T
    clear ux
    clear uy
end
%save velocity field in the whole channel
filename1=[name '_Vy_wX.mat'];
save(filename1, 'Vy_wX');
filename2=[name '_Vx_wX.mat'];
save(filename2, 'Vx_wX');

% Velocity_profiles

profile_Vy_wX=mean(Vy_wX, [1 3],'omitnan');
    
    %[Ny,Nx,N]=size(Sub_Vy);
    %save
    %plot
figure()
plot(profile_Vy_wX);

% Flow F(t)
%select the 250µm long window on which to compute the flow
%y1=181;
%y2=568;
%[row_wX,col_wX]=find(X>=x1 & X<=x2 & Y>=y1 & Y<=y2);

for i=1:N
    F_X(1,i)=mean(Vy_wX(:,:,i),'all','omitnan'); 
    %then we have to multiply by width/(scale*Dt) width in µm scale in
    %pixel/µm and dt in sec 
end

F_Xs=smooth_flow(F_X, 0.03,0.99);  
figure()
plot(F_Xs,'r');

filename3=[name '_flow.mat'];
save(filename3,'F_Xs');
end
%%
figure()
plot(Y_sub(:,1)./1.5, abs(mean(Vy_wX(:,:,:),[2 3])),'Color','r','LineWidth',2);
xlabel('y (µm)')
ylabel('V_y(y)')
%% Autocorrelation (spatial) of Vy
Cy_s=zeros(1,ny_wX);
mu=mean(Vy_wX,'all');
sigma2=var(Vy_wX,0,'all');

for s=0:ny_wX %shift in y
    c=0;
    n=0;
    for j=1:ny_wX-s
        c=c+mean((Vy_wX(j,:,:)-mu).*(Vy_wX(j+s,:,:)-mu),'all');
        n=n+1;
    end
    Cy_s(1,s+1)=c/(sigma2*n);
end
figure()
plot(Cy_s,'+-r','LineWidth',2);
%% Autocorrelation (spatial) of Vx
Cy_s=zeros(1,ny_wX);
mu=mean(Vy_wX,'all');
sigma2=var(Vy_wX,0,'all');

for s=0:ny_wX %shift in y
    c=0;
    n=0;
    for j=1:ny_wX-s
        c=c+mean((Vx_wX(j,:,:)-mu).*(Vx_wX(j+s,:,:)-mu),'all');
        n=n+1;
    end
    Cy_s(1,s+1)=c/(sigma2*n);
end
figure()
plot(Cy_s,'+-r','LineWidth',2);

%% Collect data in big matrix
scale=1.5385;
dt=0.5;
Data_ad=-Vy(idx(:),:,:)/(scale*dt);

if exist('Data.mat') %or isfile for R2019a
    
    Data=load('Data.mat');
    A=Data.Data;
    Data=cat(3,A,Data_ad);

    savename=[Parent_parent 'Data.mat'];
    save(savename,'Data');
    
else
    Data=Data_ad
    savename=[Parent_parent 'Data.mat'];
    save(savename,'Data');
  
end

%%
figure()
plot(x(:,1),mean(V,2))





%% Compute Flow Profile 
scale=1.5385;
dt=0.5;
speed=mean(V,2)/(scale*dt); %spatial average
speed_bis=speed(idx,1);
var=zeros(size(speed_bis));
speed2=zeros(size(speed_bis));

for k=1:length(idx) 
    dat=-Vy(idx(k),:,:);
    std(dat(:))
   
    var(k)=std(dat(:));
    speed_2(k)=mean(dat(:));
    
end

x_bis=X_bis(:,1)/scale;

figure()
errorbar(x_bis,speed_bis,var);

%%Save Profile

savename=[Parent nickname '_profile.mat'];
save(savename,'x_bis','speed_bis','var');

%% angle matrix
%Build matrix of thetas
theta=-atan2(Vy,Vx);

%% distribution of angles
edges=linspace(-pi,pi,100);
l=length(edges);
distribution_matrix =zeros(nx,l);
Variance=zeros(1, nx);


for k=1:nx 
    
    thet=reshape(theta(k,:,:),1,N*ny);
    %collect every value of angle that has a x coordinate
    [counts,centers]=hist(thet,edges);
    counts=counts/(N*ny);
    distribution_matrix(k,:)=counts;
    Variance(1,k)=var(thet);
end

save([nickname '_distribution_matrix.mat'],'distribution_matrix')
save([nickname '_variance.mat'],'Variance')
save([nickname '_x.mat'],'xi')
%% Plot some distribution
Color_list={[0.208 0.1663 0.5292],[0.0244 0.4350 0.8755],[0.0265 0.6137 0.8755],[0.1986 0.7214 0.6310],[0.6473, 0.7456 0.4188],[0.9856 0.7372 0.2537],[0.9763 0.9831 0.0538]};
figure()
chosen_abscisse=[1, 5, 10, 15, 20, 25, 30];
q=1
for k=chosen_abscisse
    if k<=length(xi)
        plot(centers,distribution_matrix(k,:),'Color',Color_list{1,q},'LineWidth', 1.,'DisplayName',string(k));
        q=q+1
    end
   
    hold on
        
end

hold off
legend('show');

%% Plot variance
figure(2)
plot(x,Variance)
title('Variance of the distribution of the angle of the velocity vector with respect to the distance to the wall')
xlabel('Wall distance (\mum)')
ylabel('Variance')


save('centers.mat','centers')
