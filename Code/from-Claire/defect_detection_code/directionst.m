function [DefDir]=directionst(DirStack,posCell,negCell,rect,s)

%% INPUTS
%ex_Max_Int: images of the stack, in case we want to display the overlay of the directions onto the original image
%DirStack: Matrix containing the director field, defined between [0 1],
%referring to angles between [0 pi]
%posCell: Cell containing positive defect positions
%negCell: Cell containing negative defect positions
%rect: coordinates of a cropping rectangle to remove wall effects and study
%only the defects at the center of the image
%s: downsampling factor to compute directions in a coarser mesh (our
%director field is defined at each pixel)

%% OUTPUTS
%ANGLES: Table containing all values of the measured defect directions. The
%table is used to compute statistics
%DefDir: Cell containing defect position and direction for each frame of
%the Stack

%% CODE

% posCell=negCell;
% Get the number of frames Ni
dims=size(DirStack);
if length(dims)==3
    Ni=dims(3)
else
    Ni=1;
end

% Initialize outputs;
ANGLES=[];
DefDir=cell(1,Ni);

for ni=1:Ni
    
    %Director Field
    Nx=cos(pi.*DirStack(:,:,ni));
    Ny=sin(pi.*DirStack(:,:,ni));
    
    %Create Mesh
    S=size(DirStack);
    y=1:1:S(1);
    x=1:1:S(2);
    [X,Y]=meshgrid(x,y);
    
    %Downsample Mesh by a factor s
%      s=1;
    sX=X(1:s:end,1:s:end);
    sY=Y(1:s:end,1:s:end);
    sNx=Nx(1:s:end,1:s:end);
    sNy=Ny(1:s:end,1:s:end);
    
    %Compute Q Matrix and gradients, assuming S=1 (fully aligned mesogens)
    Qxx=sNx.^2; % that is where there used to be a mistake
    Qxy=sNx.*sNy;
    Qyx=Qxy;
    Qyy=-Qxx; % traceless
    
    x1=rect(1);
    y1=rect(2);
    dx=rect(3);
    dy=rect(4);
    
%     posCell=posCell2;
    %% Compute direction around each defect
    %pick defect
    if ~isempty(posCell)
        defects=posCell{ni};
        ND=size(defects,1); %number of defects in the current frame
        Directions=NaN(ND,3);
        for n=1:ND
            pick=defects(n,:);
            xp=pick(1);
            yp=pick(2);
%             Phi=pick(3);
            Directions(n,1:2)=[xp yp];
            
            if (xp>x1)&(xp<x1+dx)           % Check if defect is inside analysis window
               if(yp>y1)&(yp<y1+dy)
                    
                    Disk=sqrt((sX-xp).^2+(sY-yp).^2);   %find closest mesh point from the defect site
                    [indy,indx]=(find(Disk<2*s));

                    if ~isempty(indx)
                        
                        values=zeros(1,length(indx));
                        for k=1:length(indx)
                            values(k)=Disk(indy(k),indx(k));
                        end
                        [v ind]=min(values);
                        
                        %Location of the defect in the mesh
                        sxc=indx(ind);
                        syc=indy(ind);
%                         plot(sX,sY,'w+')
                        %Define loop around defect
                        loop=[1 -1
                            1 0
                            1 1
                            0 1
                            -1 1
                            -1 0
                            -1 -1
                            0 -1];
                        
                        %Build coordinates of the mesh loop
                        sxl=sxc+loop(:,1);
                        syl=syc+loop(:,2);
                        %
                        %Storing Loop around the defect
                        Loop=[sxl,syl];
                        
                        % For each point of the mesh, compute the gradients
                        % and store the value in a table
                        
                        Num=zeros(1,length(Loop));
                        Denom=zeros(1,length(Loop));
                        
                        for k=1:length(Loop)
                            ii=Loop(k,2);
                            jj=Loop(k,1);
                            xQxy=(Qxy(ii,jj+1)-Qxy(ii,jj-1))/2;
                            yQyy=(Qyy(ii+1,jj)-Qyy(ii-1,jj))/2;
                            xQxx=(Qxx(ii,jj+1)-Qxx(ii,jj-1))/2;
                            yQyx=(Qyx(ii+1,jj)-Qyx(ii-1,jj))/2;
                            Num(k)=xQxy+yQyy;
                            Denom(k)=xQxx+yQyx;
                        end
                        
                        Num2=zeros(1,length(Loop));
                        Denom2=zeros(1,length(Loop));
                        for k=1:length(Loop)
                            ii=Loop(k,2);
                            jj=Loop(k,1);
                            xQxy=(Qxy(ii,jj+2)+Qxy(ii,jj+1)-Qxy(ii,jj-1)-Qxy(ii,jj-2))/4;
                            yQyy=(Qyy(ii+2,jj)+Qyy(ii+1,jj)-Qyy(ii-1,jj)-Qyy(ii-2,jj))/2;
                            xQxx=(Qxx(ii,jj+2)+Qxx(ii,jj+1)-Qxx(ii,jj-1)-Qxx(ii,jj-2))/2;
                            yQyx=(Qyx(ii+2,jj)+Qyx(ii+1,jj)-Qyx(ii-1,jj)-Qyx(ii-2,jj))/2;
                            Num2(k)=xQxy+yQyy;
                            Denom2(k)=xQxx+yQyx;
                        end
                        
                        %Averaged values 
                        N=mean(Num);
                        D=mean(Denom);
%                         N2=mean(Num2);
%                         D2=mean(Denom2);
                        Phic=atan2(-N,-D);
%                         Phic2=atan2(N2,D2);
                        ANGLES=[ANGLES;Phic];
                        Directions(n,3)=Phic;
%                         Directions(n,4)=Phic2;
                    else
                        'no loop'
                    end
                                else
                clc
                disp(['out']);
                end
            else
                clc
                disp(['out']);
            end
        end
        DefDir{ni}=Directions;    
    end
end

end

