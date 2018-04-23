% Q3
% b)
[templates, dimensions] = readInTemplates();
% c)
img = imread('thermometer.png');
imshow(img);
drawnow();
grayImg = im2double(rgb2gray(img));
[M, N] = size(grayImg);
corrArray = zeros(M, N, length(templates));
for i = 1 : length(templates)
    rgbTemp = rgb2gray(cell2mat(templates(i)));
    grayTemp = im2double(rgbTemp);
    result = normxcorr2(grayTemp, grayImg);
    [tH, tW] = size(grayTemp);
    offSetX = round(tW/2);
    offSetY = round(tH/2);
    corrArray(:,:,i) = result(offSetY : offSetY + M - 1, offSetX : offSetX + N-1);
end
% d)
[maxCorr, maxIdx] = max(corrArray,[],3);
% e)
T = 0.7;
[candY, candX] = find(maxCorr > T);
% f)
for i = 1 : length(candX)
    % f) i.
    templateIndex = maxIdx(candY(i), candX(i));
    thisCorr = corrArray(:,:, templateIndex);
    if isLocalMaximum(candX(i), candY(i), thisCorr)
        drawAndLabelBox(candX(i), candY(i), templateIndex, dimensions);
        drawnow();
    end
end

% f) ii.
function result = isLocalMaximum(x, y, thisCorr)
x1 = x - 1;
x2 = x + 1;
y1 = y - 1;
y2 = y + 1;
[M, N] = size(thisCorr);
if x1 < 1
    x1 = 1;
    x2 = 2;
end
if x2 > N
    x1 = N-1;
    x2 = N;
end
if y1 < 1
    y1 = 1;
    y2 = 2;
end
if y2 > M
    y1 = M-1;
    y2 = M;
end
result = max(thisCorr(y1:y2,x1:x2)) <= thisCorr(y, x);
end

