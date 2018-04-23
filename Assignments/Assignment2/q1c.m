clear all;
close all;
im = imread('building.jpg');
img = mean(double(im), 3);
img = conv2(img, fspecial('gaussian',6,3), 'same');
figure();imagesc(im); axis image; drawnow; hold on;

imgS = img;
k = 1.2;
sigma = 2.0;
s = k.^(1:50)*sigma;
responseLoG = zeros(size(img,1),size(img,2),length(s));
imG = zeros(size(img,1),size(img,2),length(s));

for i = 1:length(s)
    si = s(i);
    hsize = max(25,min(floor(si*3),256));
%     hsize = max(50,floor(si*3));
    LoG = fspecial('log', [hsize hsize], si);
    filteredImg = conv2(imgS,LoG,'same');
    responseLoG(:,:,i)  = (si^2)*filteredImg;
end

threshold = 0.748 * max(abs(responseLoG(:)));

[height, width, scaleIdx] = size(responseLoG);

for i = 2 : scaleIdx-1
    for y = 2 : height-1
        for x = 2 : width-1
            neighbours = abs(responseLoG(y-1:y+1,x-1:x+1,i-1:i+1));
            localMax = max(neighbours(:));
            curr = abs(responseLoG(y,x,i));
            if curr == localMax && localMax > threshold && length(find(neighbours==localMax))==1
                scale = s(i);
                xc = scale*sin(0:0.1:2*pi)+x;
                yc = scale*cos(0:0.1:2*pi)+y;
                plot(xc,yc,'r');drawnow;
            end
        end
    end
end
hold off;
