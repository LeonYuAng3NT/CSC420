function [Y, X] = q1_b_non_maximum_suppression(cornerness, radius, threshold)
    % Create circular mask
    [row, col] = meshgrid(1:(radius * 2));
    mask = sqrt((row - radius).^2+(col - radius).^2) <= radius;
    localMax = ordfilt2(cornerness, radius ^ 2, mask);
    [Y, X] = find(localMax > threshold & cornerness == localMax);
end