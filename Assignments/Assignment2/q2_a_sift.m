function [f, d]= q2_a_sift(image)
    im= imread(image);
    img=single(rgb2gray(im));

    [f,d]=vl_sift(img);

    figure();
    imshow(im);
    perm = randperm(size(f,2)) ;
    sel = perm(:) ;
    h1 = vl_plotframe(f(:,sel)) ;
    h2 = vl_plotframe(f(:,sel)) ;
    set(h1,'color','k','linewidth',3) ;
    set(h2,'color','y','linewidth',2) ;
end