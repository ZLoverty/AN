function out = fndstruct(sigma1,sigma2,im)
% out = fndstruct(sigma1,sigma2,image)
% function returns the structure tensor orientation for an input image and
% the standard deviations of the gaussian filters that will be used.
%
% INPUTS:
% sigma1 = standard deviation of the gaussian filter applied to the
%   original image. The size of the filter will be 6*sigma1-1, so value
%   must be 0.5 or an integer. This filter is for noise removal.
% sigma2 = standard deviation of the gaussian filter applied to construct
%   structure tensor(s) from the gradient tensor(s). The filter size will
%   be 6*sigma2-1 and sigma2 should be on the order of the anisotropy in
%   the image. sigma2 should typically at least 3-4 times larger than
%   sigma1.
% im = [A x B] input image. im should be a b/w image of type double with min 0
%   and max 1.
%
% OUTPUT:
% out = [A x B] output image containing the "coherence orientation" derived from the
%   eigenvector associated with the smallest eigenvalue of its structure
%   tensor. The orientation takes values from (0,pi] measured wrt the 
%   x-axis mapped to the values (0,1] in the image. 
%fnameM='100/Mask_channel7_100.tif';
%infoM=imfinfo(fnameM);
%thres=0.7;
%Mask=imread(fnameM,1);
%Mask=Mask>thres;

out = zeros(size(im)); % initialize the output image
filt = fspecial('gaussian',6*sigma1-1,sigma1); %make the appropriate filters
filt2 = fspecial('gaussian',6*sigma2-1,sigma2);

imG = imfilter(im, filt,'conv');
figure(1)
%imshow(Mask.*imG)%smooth the original image
[gx,gy] = imgradientxy(imG); %take the gradient
gxgx = gx.*gx; %matricies representing elements of [gx^2, gxgy; gygx, gy^2] for each pixel
gxgy = gx.*gy;
gygy = gy.*gy;

GxGx = imfilter(gxgx,filt2,'conv'); %construct the elements of the structure tensor for each pixel using the 2nd fundamental form and the 2nd gaussian
GxGy = imfilter(gxgy,filt2,'conv'); 
GyGy = imfilter(gygy,filt2,'conv'); 

for ind = 1:(size(im,1)*size(im,2)) %find the coherence orientation for each pixel
   [V,D] = eig([GxGx(ind),GxGy(ind);GxGy(ind),GyGy(ind)]);
   if D(1) < D(4)
       out(ind) = atan2(V(2),V(1));
   else
       out(ind) = atan2(V(4),V(3));
   end
end
out(out<=0)=(out(out<=0)+pi); %fold the values from [-pi,pi] to (0,pi]
out = out/pi; %rescale the values to (0,1]


end