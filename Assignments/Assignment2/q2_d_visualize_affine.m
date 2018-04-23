function q2_d_visualize_affine(img1, img2, affine)
    im1 = imread(img1);
    im2 = imread(img2);
    [H1, W1, L1] = size(im1);
    P = [1,1,0,0,1,0;
         0,0,1,1,0,1;
         W1,1,0,0,1,0;
         0,0,W1,1,0,1;
         1,H1,0,0,1,0;
         0,0,1,H1,0,1;
         W1,H1,0,0,1,0;
         0,0,W1,H1,0,1];
    P1 = P * affine;
    figure; imshow(im2); hold on;
    plot([P1(1) P1(3)], [P1(2) P1(4)], 'r', 'LineWidth', 2);
    plot([P1(1) P1(5)], [P1(2) P1(6)], 'r', 'LineWidth', 2);
    plot([P1(7) P1(5)], [P1(8) P1(6)], 'r', 'LineWidth', 2);
    plot([P1(7) P1(3)], [P1(8) P1(4)], 'r', 'LineWidth', 2);

end