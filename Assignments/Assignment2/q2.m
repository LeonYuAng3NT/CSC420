close all;
clear all;
img1 = 'book.jpg';
img2 = 'findBook.jpg';
% a)
[f1, d1] = q2_a_sift(img1);
[f2, d2] = q2_a_sift(img2);

% b)
thresholds = [0.6, 0.7, 0.8];
figure;hold on;
for i=1:3
    match = q2_b_matching_algo(d1, d2, thresholds(i));
    % draw imgaes and lines
    im1=imread(img1);
    im2=imread(img2);
    [H1, W1, L1] = size(im1);
    [H2, W2, L2] = size(im2);
    H = max(H1, H2);
    W = max(W1, W2);
    impad1 = padarray(im1, [H-H1,W-W1], 'post');
    impad2 = padarray(im2, [H-H2,W-W2], 'post');
    subplot(3,1,i);
    imagesc([impad1 impad2]);hold on; 

    for j = 1:size(match, 1)
        x1 = f1(1, match(j, 1));
        y1 = f1(2, match(j, 1));
        x2 = f2(1, match(j, 2))+W;
        y2 = f2(2, match(j, 2));
        plot([x1 x2], [y1 y2], 'r', 'LineWidth', 2);
        title(strcat('threshold=', num2str(thresholds(i)))); 

    end
end
% c)
affine = q2_c_affine(f1,f2,match,4);

% d)
q2_d_visualize_affine(img1, img2, affine);

% e)
imgC1 = 'colourTemplate.png';
imgC2 = 'colourSearch.png';
[fC1, dC1] = q2_e_sift_colour(imgC1);
[fC2, dC2] = q2_e_sift_colour(imgC2);
matchC = q2_b_matching_algo(dC1, dC2, 0.5);
affineC = q2_c_affine(fC1,fC2,matchC,4);
q2_d_visualize_affine(imgC1, imgC2, affineC);