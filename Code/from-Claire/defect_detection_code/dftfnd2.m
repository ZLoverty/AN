function [pos,neg]=dftfnd2(S_in,Dir,isin,th)
% [pos,neg]=dftfnd2(S_in,Dir,isin,th)
%
% function that finds +/1 1/2 defects given the scalar order parameter and
% the director. algortihm calculates the angular change in the director and
% looks to see is the total change is +/- pi
%
% INPUTS
% S_in - [A x B] double array of scalar order paramter values. These values
%        should be greater than 0
% Dir_in - [A x B] double array of director orientations where the values
%          [0,1) map to [0, pi] radians. Orientations are measured from the
%          x-axis
% isin - [A x B] logical array giving the area of interest to find defects.
%        1's represent pixels in the area of interest
% th - scalar threshold value. The algorithm will test any pixel with a
%      scalar order paramter less than this threshold
%
% OUTPUTS
% pos - [np x 2] array where each rox is the [x, y] position of a positive
%       defect
% neg - [nn x 2] array where each rox is the [x, y] position of a negative
%       defect
%
% written by Perry Ellis - pellis30@gatech.edu
%

S = S_in;

ind=find(S < th); %thresh S
[nr,nc]=size(S);
n=length(ind);
if n==0
    pos=[];neg=[];
    display('nothing below threshold');
    return;
end
mx=[];
%convert index from find to row and column
rc=[mod(ind,nr),floor(ind/nr)+1];
hL = 2; %radius of the path around the defect to walk
for i=1:n
    r=rc(i,1);c=rc(i,2);
    %check each pixel below threshold to see if it's darker than its neighbors
    if r>2&&c>2&&r<(size(isin,1)-2)&&c<(size(isin,2)-2)&&isin(r,c)==1 %limit RoI
        if S(r,c)==min(min(S(r-hL:r+hL,c-hL:c+hL)))
            if sum(sum(S(r,c)== S(r-hL:r+hL,c-hL:c+hL)))>1
                S(r,c) = NaN;
            else
                %one = flip(st(r-hL,c-hL:c+hL)); % this is the upper leg from r2l
                %two = st((r-hL+1):(r+hL-1),c-hL)'; %this is the left leg from t2b
                %three = st(r+hL,c-hL:c+hL); %this is the bot leg from l2r
                %four = flip(st((r-hL+1):(r+hL-1),c+hL)'); %this is the right leg from b2t
                %dirsCCW = [one,two,three,four]; %replaced with direct
                %implementation... use this to find defect charge

                dirsCCW = [flip(Dir(r-hL,c-hL:c+hL)),Dir((r-hL+1):(r+hL-1),c-hL)',Dir(r+hL,c-hL:c+hL),flip(Dir((r-hL+1):(r+hL-1),c+hL)')];
                diffDirs = circshift(dirsCCW,[0,1])-dirsCCW;%find the difference between subsequent points
                diffDirs(diffDirs>0.5) = diffDirs(diffDirs>0.5)-1;
                diffDirs(diffDirs<-0.5) = diffDirs(diffDirs<-0.5)+1;
                %diffDirs(diffDirs.^2>0.4)=0; %remove the large overlap contribution for pi-0
                if abs(sum(diffDirs))>0.99 %enforce minimum charge of 0.5
                    mx=[mx,[r,c,ceil(mean(diffDirs))]']; %the 3rd element is +1 for a +1/2 defect and 0 for a -1/2 defect
                   %uncomment below to step through defects
%                     figure(1)
%                     imshow(Dir)
%                     hold on
%                     plot(c,r,'g*')
%                     hold off
%                     figure(4)
%                     imshow(S_in)
%                     hold on
%                     plot(c,r,'g*')
%                     hold off
%                     figure(2)
%                     plot(dirsCCW,'rx')
%                     figure(3)
%                     plot(diffDirs,'bx')
%                     disp(['mean of diffDirs is ' num2str(mean(diffDirs)) '. sign is defect charge'])
%                     disp(['S = ' num2str(S(r,c))])
%                     disp(['sum of angular differences is ' num2str(sum(diffDirs))])
%                     pause
                end
            end
        end
    end
end
mx = mx'; %note still in ROW/COL format
isempty(mx)
if ~isempty(mx)
posR = find(mx(:,3)==1);
pos = [mx(posR,2),mx(posR,1)]; % sort the charge and change to x,y representation
negR = find(mx(:,3)==0);
neg = [mx(negR,2),mx(negR,1)];

else
    pos=[];
    neg=[];
    clc
end
