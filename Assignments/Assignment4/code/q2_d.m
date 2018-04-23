clear all;
close all;

imageIds = getData([], 'test', 'list');
imageIds = imageIds.ids;

labels = [{'car'}, {'person'}, {'bicycle'}];

for i = 1:size(imageIds)
    id = char(imageIds(i));
    calib = getData(id, 'test', 'calib');
    
    % from part a) - calcualte depth first
    disparity = getData(id, 'test', 'disp');
    disparity = double(disparity.disparity);

    [row, col] = size(disparity);
    depth = zeros(row, col);
    
    for j = 1:row
        for k = 1:col
            depth(j,k) = (calib.f - calib.baseline) / disparity(j,k);
        end
    end
    
    % find center of mass
    
    result = getData(id,[],'result');
    result = result.result;
    px = calib.K(1,3);
    py = calib.K(2,3);
    f = calib.f;
    
    car = zeros(size(result.car, 1), 3);
    person = zeros(size(result.person, 1), 3);
    bicycle = zeros(size(result.bicycle, 1), 3);
    
    location3d = struct('car', car, 'person', person, 'bicycle', bicycle);
    
    for j = 1:3
        ds = result.(labels{j});
        location = zeros(size(ds, 1), 3);
        for k = 1:size(ds, 1)
            xcent = (ds(k, 3) + ds(k, 1)) / 2;
            ycent = (ds(k, 4) + ds(k, 2)) / 2;
            z = depth(round(ycent), round(xcent));
            x = (xcent - px) * z / f;
            y = (ycent - py) * z / f;
            location(k,:) = [x, y, z];
        end
        location3d.(labels{j}) = location;
    end
    
    save(sprintf('../results/%s_3d.mat', id), 'location3d');
end