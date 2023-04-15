

clear all
close all

load('P_xy.mat');
n1 = size(P_x0, 2);
P_x0(2 : n1 + 1) = P_x0(:);
P_y0(2 : n1 + 1) = P_y0(:);
% 电源位于区域的中心,(rand*10-5)
P_x0(1) = 50 + 3.0191;
P_y0(1) = 50 + (-0.0259);

[G_3, P_x, P_y, fval, r] = SSDN_model(P_x0, P_y0);
fval
save('t1_best', 'G_3', 'P_x', 'P_y', 'fval', 'r');

