clear all;
close all;

labels = [{'car'}, {'person'}, {'bicycle'}];
threshold = [.1, .3, .9];
detectors = struct('car', 2, 'person', 3, 'bicycle', 3);
color = ['r', 'b', 'c'];

for i = 1:3
    data = getData([], [], sprintf('detector-%s', char(labels(i))));
    detectors.(labels{i}) = data.model;
end

imgIds = getData([], 'test', 'list');
imgIds = imgIds.ids;

for i = 1:size(imgIds)
    
    imdata = getData(char(imgIds(i)), 'test', 'left');
    im = imdata.im;
    f = 1.5;
    imr = imresize(im,f);
    
    result = struct('car', 6, 'person', 6, 'bicycle', 6);
    
    fprintf('Testing image #%i\n', i);

    for j = 1:3
        fprintf('    For target object - %s\n' , char(labels(j)));
        fprintf('       running the detector, may take a few seconds...\n');
        tic;
        model = detectors.(labels{j});
        [ds, bs] = imgdetect(imr, model, model.thresh*threshold(j));
        % you may need to reduce the threshold if you want more detections
        e = toc;
        fprintf('       finished! (took: %0.4f seconds)\n', e);
        nms_thresh = 0.5;
        top = nms(ds, nms_thresh);
        if model.type == model_types.Grammar
            bs = [ds(:,1:4) bs];
        end
        if ~isempty(ds)
            % resize back
            ds(:, 1:end-2) = ds(:, 1:end-2)/f;
            bs(:, 1:end-2) = bs(:, 1:end-2)/f;
        end;
        ds = ds(top, :);
        result.(labels{j}) = ds;
    end
    
    save(sprintf('../results/%s.mat', string(imgIds(i))), 'result');
    
end