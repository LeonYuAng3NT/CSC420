close all;
clear all;
% q1 a
im = imread('building.jpg');
image = im2double(rgb2gray(im));

% compute gradient
[dx, dy] = imgradientxy(image);

% compute Ix2 Iy2 IxIy
Ix2 = dx.^2;
Iy2 = dy.^2;
IxIy = dx.*dy;

% compute Guassian average
sigma = 2;
Ix2 = imgaussfilt(Ix2, sigma);
Iy2 = imgaussfilt(Iy2, sigma);
IxIy = imgaussfilt(IxIy, sigma);



alpha = 0.001;
[height, width] = size(image);
cornerness = zeros(size(image));
for i = 1 : height
    for j = 1 : width
        M =  [Ix2(i,j), IxIy(i,j); IxIy(i,j), Iy2(i,j)];
        % Harris and Stephens
        cornerness(i,j) = det(M) - alpha * trace(M);
        % Brown et al
%         cornerness(i,j) = det(M) / trace(M);
    end
end
Rmax = max(cornerness);

figure();
imagesc(cornerness);

% q1 b
threshold = 0.01;
figure();
radii = [3, 5, 10, 20];
    [Y, X] = q1_b_non_maximum_suppression(cornerness, 10, threshold);
    imshow(im);
    hold on;
    axis;
    plot(X, Y, 'r.'); 