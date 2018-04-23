close all;
im = double(rgb2gray(imread('shoe.jpg')));
billCorners = [0, 0;
    0, 152.4;
    69.85, 152.4;
    69.85, 0];
figure; imagesc(im);colormap gray;

bilCornersImg = ginput(4);
transform = fitgeotrans(bilCornersImg, billCorners, 'projective');
transformed = imwarp(im, transform, 'bicubic', 'fill', 0);
figure; imagesc(transformed); colormap gray; hold on;

line1 = ginput(2);
x1 = line1(:,1);
y1 = line1(:,2);
plot(x1, y1, 'y-');
m1 = midpoint(1,line1.');
text(m1(1), m1(2), strcat('\leftarrow ', num2str(pdist(line1, 'euclidean') / 10, 3), ' cm'), 'Color', 'yellow', 'FontSize', 14); 

line2 = ginput(2);
x2 = line2(:,1);
y2 = line2(:,2);
plot(x2, y2, 'r--');
m2 = midpoint(1,line2.');
text(m2(1), m2(2), strcat('\leftarrow ', num2str(pdist(line2, 'euclidean') / 10, 3), ' cm'), 'Color', 'red', 'FontSize', 14); 

