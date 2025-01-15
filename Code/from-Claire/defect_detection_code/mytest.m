img = imread("C:\Users\zl948\Documents\AN\kymo\08_C-2100.tif");
imshow(img);

st = fndstruct(1, 10, img);
figure;
imshow(st);

%%
[SS, NN] = qTensor(st, 5);
figure();
imshow(SS);
figure();
imshow(NN);


%%
SOP = SS; % scalar order parameter
DIR = NN; % director field
mask = ones(size(img));
thres = 0.02;
[pos, neg] = dftfnd2(SOP, DIR, mask, thres);

%%
figure();
imshow(img);
ax = gca()
hold on;
scatter(pos(:,1), pos(:,2), "filled");
scatter(neg(:,1), neg(:,2), "filled", "Color", "r");
hold off;

%%
fname = "test-images\sample-image-AN.tif";
img = imread(fname);
Mask = ones(size(img)) > 0;
screening(fname,Mask,'m',1);

%% compute bending energy

dx = 0.65; 
K1 = 1.0; % Splay elastic constant
K2 = 1.0; % Twist elastic constant
K3 = 1.0; % Bend elastic constant

% convert one-number director representation (0,pi] to 2D representation
[nx, ny] = size(NN);
n = zeros(nx, ny, 1, 2);
n(:,:,:,1) = cos(NN*pi);
n(:,:,2) = sin(NN*pi);

% Compute gradients and curl of the director field
[grad_n, div_n, curl_n] = compute_gradients_and_curl(n, dx);

% Compute the splay, twist, and bend contributions
splay = 0.5 * K1 * (div_n.^2); % Splay energy density
twist = 0
bend = 0.5 * K3 * (curl_n.^2); % Bend energy density

% Total elastic energy density
f_elastic = splay + twist + bend;

% Total elastic energy
F_elastic = sum(f_elastic(:)) * (dx^3);

% Display total elastic energy
disp(['Total elastic energy: ', num2str(F_elastic)]);

% Auxiliary functions
function [grad_n, div_n, curl_n] = compute_gradients_and_curl(n, dx)
    % Compute gradient of director field (2D)
    grad_n = cell(2, 1);
    for i = 1:2
        [grad_n{1, i}, grad_n{2, i}] = gradient(n(:,:,i), dx); % Gradient for each component
    end
    
    % Compute divergence (sum of the gradients)
    div_n = grad_n{1,1}(:,:) + grad_n{2,2}(:,:); % Divergence of n
    
    % Compute curl (2D curl in z-direction)
    curl_n = grad_n{1,2}(:,:) - grad_n{2,1}(:,:); % Curl in 2D (z-component)
end