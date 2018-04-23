clear all;
close all;

imageIds = getData([], 'test', 'list');

labels = [{'car'}, {'person'}, {'bicycle'}];
color = ['r', 'b', 'c'];

figure();

for i = 1:3
    id = char(imageIds.ids(i));
    result = getData(id,[],'result');
    result = result.result;
    imdata = getData(id, 'test', 'left');
    im = imdata.im;
    subplot(3,1,i); imshow(im); title(id); hold on;
    for j = 1:3
        ds = result.(labels{j});
        for k = 1:size(ds, 1)
            x = ds(k, 1);
            y = ds(k, 2);
            w = ds(k, 3) - ds(k, 1);
            h = ds(k, 4) - ds(k, 2);
            rectangle('Position',[x y w h], 'EdgeColor', color(j), 'LineWidth', 2);
            text(x, y-12, char((labels{j})), 'color', color(j));
            hold on;
        end
    end
end