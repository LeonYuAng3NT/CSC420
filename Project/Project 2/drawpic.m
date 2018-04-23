
img = imread('data/Detection/img8/img8.bmp');
img1 = rgb2hsv(img);
detection = load('data/Detection/img8/img8_detection.mat');
detection=detection.detection;
figure();subplot(1,2,1); imshow(img); axis image; title 'RBG image'; hold on;
count = 5;
for j = 1:count
    c = detection(j, :);
    x = round(c(1));
    y = round(c(2));
    x1 = max(1, x-13);
    x2 = min(500, x+13);
    y1 = max(1, y-13);
    y2 = min(500, y+13);
    if x1 == 1
        x2 = 27;
    end
    if x2 == 500
        x1 = 474;
    end
    if y1 == 1
        y2 = 27;
    end
    if y2 == 500
        y1 = 474;
    end
    patch = img(y1:y2, x1:x2,:);
    intensity = img1(y1:y2, x1:x2,3);
    subplot(count,5, (j-1)*5+1); imshow(patch); hold on;
    subplot(count,5, (j-1)*5+2); imshow(intensity); hold on;
    [~,hogVisualization] = extractHOGFeatures(patch);
    subplot(count,5, (j-1)*5+3); plot(hogVisualization); hold on;
    [~,hogVisualization] = extractHOGFeatures(patch, 'CellSize', [5 5]);
    subplot(count,5, (j-1)*5+4); plot(hogVisualization); hold on;
    [~,hogVisualization] = extractHOGFeatures(patch, 'CellSize', [3 3]);
    subplot(count,5, (j-1)*5+5); plot(hogVisualization); hold on;
    
end
