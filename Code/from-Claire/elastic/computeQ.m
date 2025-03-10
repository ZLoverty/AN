% unsmoothed
Q11 = asymA(:,:,1,1);
Q12 = asymA(:,:,1,2);
Q22 = asymA(:,:,2,2);
mask = imread("mask\A07.tif");
mask = mask > mean(mask);
%%
ee = elasticCost(Q11, Q12, Q22);
ee(~mask) = nan;
%%
fig = figure("Name", "unsmoothed");
imshow(log(ee));
colormap jet;
colorbar;
caxis([-9, -5]);
saveas(fig, "unsmoothed.png");
%% smoothed
Q11 = asymAs(:,:,1,1);
Q12 = asymAs(:,:,1,2);
Q22 = asymAs(:,:,2,2);
%%
ee = elasticCost(Q11, Q12, Q22);
ee(~mask) = nan;
%%
fig = figure("Name", "smoothed")
imshow(log(ee));
colormap jet;
colorbar;
caxis([-9, -5]);
saveas(fig, "smoothed_10.png");
%% downsampled
Q11 = asymA(:,:,1,1);
Q12 = asymA(:,:,1,2);
Q22 = asymA(:,:,2,2);
q11 = sample_field(Q11, 16);
q12 = sample_field(Q12, 16);
q22 = sample_field(Q22, 16);
mask_down = sample_field(mask, 16);
%%
ee = elasticCost(q11, q12, q22);
ee(~mask_down) = nan;
%%
fig = figure("Name", "downsampled")
imshow(log(ee/16/16));
colormap jet;
colorbar;
caxis([-9, -5]);
% Fit the axis to the figure
axis tight;
saveas(fig, "downsampled_16.png");