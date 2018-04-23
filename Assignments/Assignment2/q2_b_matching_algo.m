function [match] = q2_b_matching_algo(d1, d2, threshold, img1, img2)
    desc1 = transpose(double(d1));
    desc2 = transpose(double(d2));
    dist = pdist2(desc1, desc2);
    [closest, I] = min(dist, [], 2);
    sortedDist = sort(dist, 2, 'ascend');
    secondClosest = sortedDist(:,2);
    match = [];
    ratio = [];
    for i = 1:length(closest)
        phi = closest(i)/secondClosest(i);
        if phi < threshold
            match = cat(1, match, [i, I(i), phi]);
        end
    end    
end