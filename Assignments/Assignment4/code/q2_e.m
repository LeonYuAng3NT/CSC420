imageIds = getData([], 'test', 'list');
imageIds = imageIds.ids;

labels = [{'car'}, {'person'}, {'bicycle'}];

for n = 1:size(imageIds)
    id = char(imageIds(n));
    calib = getData(id, 'test', 'calib');
    
    % from part a) - calcualte depth first
    disparity = getData(id, 'test', 'disp');
    disparity = double(disparity.disparity);
    [row, col] = size(disparity);
    depth = zeros(row, col);
    for i = 1:row
        for j = 1:col
            depth(i,j) = (calib.f - calib.baseline) / disparity(i,j);
        end
    end
    
    % find segmentations
    segmentation = zeros(row, col);
    object = 1;
    result = getData(id,[],'result');
    result = result.result;
    objectLocation = getData(id, [], 'object-location');
    objectLocation = objectLocation.location3d;
    px = calib.K(1,3);
    py = calib.K(2,3);
    f = calib.f;
    
    for j = 1:3
        ds = result.(labels{j});
        location = objectLocation.(labels{j});
        for k = 1:size(ds, 1)
            com = location(k,:);
            left = max(1, floor(ds(k,1)));
            right = min(col, ceil(ds(k,3)));
            top = max(1, floor(ds(k,2)));
            bottom = min(row, ceil(ds(k,4)));
            for x = left:right
                for y = top:bottom
                    z = depth(y, x);
                    x1 = (x - px) * z / f;
                    y1 = (y - py) * z / f;
                    if (norm(com - [x1, y1, z]) <= 3)
                        segmentation(y, x) = object;
                    end
                end
            end
            object = object + 1;
        end
    end
    save(sprintf('../results/%s_seg.mat', id), 'segmentation');
end

% visualize first three images
figure();
for i=1:3
    id = char(imageIds(i));
    file = fullfile(sprintf('../results/%s_seg.mat', id));
    segmentation = load(file);
    segmentation = segmentation.segmentation;
    subplot(3,1,i); imagesc(segmentation); title(id); hold on;
end