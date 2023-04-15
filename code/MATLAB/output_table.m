

clear all

% load('test_data.mat');
% dem = dem(:);
% P_x0 = P_x0(:);
% P_y0 = P_y0(:);
% load_info = [P_x0, P_y0, dem];

% load('t1_best.mat');
% % 输出分叉点坐标以及用电可靠性
% 
% G_bool = logical(G_3);
% G_int = int32(G_bool);
% G_col_cum = sum(G_int);
% node_leaf = find(G_col_cum <= 1);
% K1 = 1;
% node_blue = [K1, node_leaf];
% node = [1 : size(G_col_cum, 2)];
% node_red = setdiff(node, node_blue);
% bifu_info = zeros(size(node_red, 2), 3);
% bifu_info(:, 1) = node_red;
% bifu_info(:, 2) = P_x(node_red);
% bifu_info(:, 3) = P_y(node_red);
% 
% load_info = zeros(size(node_leaf, 2), 4);
% load_info(:, 1) = node_leaf;
% load_info(:, 2) = P_x(node_leaf);
% load_info(:, 3) = P_y(node_leaf);
% load_info(:, 4) = r(node_leaf);

% load('t2_best.mat');
% G_3 = blkdiag(G_3_s1_best, G_3_s2_best);
% P_x = [P_x_s1_best, P_x_s2_best];
% P_y = [P_y_s1_best, P_y_s2_best];
% r = [r_s1_best; r_s2_best]
% 
% G_bool = logical(G_3);
% G_int = int32(G_bool);
% G_col_cum = sum(G_int);
% node_leaf = find(G_col_cum <= 1);
% K1 = 1; K2 = size(G_3_s1_best, 1) + 1;
% node_blue = [K1, K2, node_leaf];
% node = [1 : size(G_col_cum, 2)];
% node_red = setdiff(node, node_blue);
% node_info = zeros(size(G_col_cum, 2), 5);
% node_info(:, 1) = 1 : size(G_col_cum, 2);
% node_info([K1 K2], 2) = 1;
% node_info(node_red, 2) = 2;
% node_info(node_leaf, 2) = 3;
% node_info(:, 3) = P_x(:);
% node_info(:, 4) = P_y(:);
% node_info(node_leaf, 5) = r(node_leaf);







