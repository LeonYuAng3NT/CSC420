imageIds = getData([], 'test', 'list');
imageIds = imageIds.ids;

labels = [{'car'}, {'person'}, {'bicycle'}];

for i = 1:1
    id = char(imageIds(i));
    objectLocation = getData(id, [], 'object-location');
    objectLocation = objectLocation.location3d;
    file = fopen(sprintf('../results/%s_info.txt', id), 'a+');
    fprintf(file, 'In the scene #%s\n', id);
    for j = 1:3
        location = objectLocation.(labels{j});
        count = size(location, 1);
        fprintf(file, 'There are %i %s(s)\n', count, labels{j});
        if count > 0
            x = 0;
            closest = intmax;
            for k = 1:size(location)
                distance = norm(location(k,:));
                if distance < closest
                    closest = distance;
                    x = location(k,1);
                end
            end
            if x >= 0
                txt = 'to your right';
            else 
                txt ='“to your left';
            end;
            fprintf(file, 'The closest one is a %s %0.1f meters %s \n', labels{j}, x, txt); 
            fprintf(file, 'It is %0.1f meters away from you \n', closest);
        end
    end
end