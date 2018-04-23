close all;

% Depth Intrinsic Parameters
fx_d = 5.8262448167737955e+02;
fy_d = 5.8269103270988637e+02;
px_d = 3.1304475870804731e+02;
py_d = 2.3844389626620386e+02;

K = [fx_d, 0, px_d;
     0, fy_d, py_d;
     0, 0, 1];

% Rotation
R = -[ 9.9997798940829263e-01, 5.0518419386157446e-03, ...
   4.3011152014118693e-03, -5.0359919480810989e-03, ...
   9.9998051861143999e-01, -3.6879781309514218e-03, ...
   -4.3196624923060242e-03, 3.6662365748484798e-03, ...
   9.9998394948385538e-01 ];

R = reshape(R, [3 3]);
R = inv(R');

Ro = zeros(4, 4);
Ro(1:3, 1:3) = R;
R(4, 4) = 1;

% 3D Translation
t_x = 2.5031875059141302e-02;
t_z = -2.9342312935846411e-04;
t_y = 6.6238747008330102e-04;

t = eye(4);
t(1,4) = t_x;
t(2,4) = t_y;
t(3,4) = t_z;

rgbd = load('rgbd.mat');
im = rgbd.im;
depth = rgbd.depth;
labels = rgbd.labels;
imshow(im);
% imagesc(depth);
x = 1:size(im,2);
y = 1:size(im,1);

fig = surf(x,y,depth,im,'facecolor','texturemap','EdgeColor','none');
% view([1,1,-1]);
% view(0, -45);
% pcloud=depthToCloud(depth);
% surf(pcloud(:,:,3),-pcloud(:,:,1),-pcloud(:,:,2),im,'facecolor','texturemap','EdgeColor','none');


