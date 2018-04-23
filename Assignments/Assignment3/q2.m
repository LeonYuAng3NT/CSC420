close all;
run('/Users/stivo/Downloads/vlfeat-0.9.20/toolbox/vl_setup');
im = double(rgb2gray(imread('mugShot.jpg')));
% a) test case
% from https://www.mathworks.com/discovery/affine-transformation.html
translation = [1, 0, 0;
               0, 1, 0;
               50, 50, 1];
scale = [.5, 0, 0;
         0, .7, 0;
         0, 0, 1];
shear = [1, 0.2, 0;
         0.1, 1, 0;
         0, 0, 1];
rotation = [cos(45*pi/180), sin(45*pi/180), 0;
            -sin(45*pi/180), cos(45*pi/180), 0;
            0, 0, 1];
A = translation * scale * shear * rotation;
tform = affine2d(A);
testIm = imwarp(im, tform, 'bicubic', 'fill', 0);
figure; 
subplot(1,2,1);imagesc(im); title('original image'); colormap gray;hold on;

% adopted;
[f1,d1]=vl_sift(single(im));
[f2,d2]=vl_sift(single(testIm));
match = matching_algo(d1, d2, 0.8);

% run ransac
affine = ransac(f1, f2, match, 50);
visualize_affine(im, testIm, affine);
% subplot(1,2,2);imagesc(testIm); title('test image'); colormap gray;

% b)
imageFiles = dir('shredded/*.png');
imageNum = length(imageFiles);
shreddedImg = cell(imageNum,1);
for i = 1:imageNum
    cut = double(rgb2gray(imread(strcat('shredded/', imageFiles(i).name))));
    shreddedImg(i) = mat2cell(cut, size(cut,1), size(cut,2));
end

permutations = perms(1:imageNum);
minMeanResidualSSD = intmax;
reassembledIm = 0;
for i = 1:2
    fprintf('testing permutation #%i\n', i);
    order = permutations(i,:);
    reassembled = zeros(size(im));
    leftEdge = 1;
    for j = 1:imageNum
        cut = cell2mat(shreddedImg(order(j)));
        cutW = size(cut,2);
        reassembled(:,leftEdge:leftEdge+cutW-1) = cut;
        leftEdge = leftEdge + cutW;
    end
    [f3,d3]=vl_sift(single(reassembled));
    match = matching_algo(d1, d3, 0.8);
    meanResidualSSD = ransacReassemble(f1, f3, match, 50);
    if meanResidualSSD < minMeanResidualSSD
        minMeanResidualSSD = meanResidualSSD;
        reassembledIm = reassembled;
    end
end

figure; imagesc(reassembledIm); colormap gray;