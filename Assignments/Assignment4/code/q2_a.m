clear all;
close all;

imageIds = getData([], 'test', 'list');

figure();

for n = 1:3
    id = char(imageIds.ids(n));
    
    calib = getData(id, 'test', 'calib');
    disparity = getData(id, 'test', 'disp');
    disparity = double(disparity.disparity);

    [row, col] = size(disparity);
    depth = zeros(row, col);
    
    for i = 1:row
        for j = 1:col
            depth(i,j) = (calib.f - calib.baseline) / disparity(i,j);
        end
    end

    subplot(3, 1, n);
    image(depth);
end