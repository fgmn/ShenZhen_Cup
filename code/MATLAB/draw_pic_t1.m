clear all
close all

load('t1_best.mat');

G_bool = logical(G_3);
G_int = int32(G_bool);
G_col_cum = sum(G_int);
node_leaf = find(G_col_cum <= 1);
K1 = 1;
node_blue = [K1, node_leaf];
node = [1 : size(G_col_cum, 2)];
node_red = setdiff(node, node_blue);

figure
G_n = graph(G_3);
node_col = zeros(size(G_col_cum, 2), 3);
for i = 1 : size(node_blue, 2)
    node_col(node_blue(i), :) = [0 0.4470 0.7410];
end
for i = 1 : size(node_red, 2)
    node_col(node_red(i), :) = [1 0 0];
end
node_col(i, :) = [1 0 0];
node_size = zeros(1, size(G_col_cum, 2));
node_size(:) = 6;
node_size(K1) = 12;
h = plot(G_n, 'NodeColor', node_col, 'MarkerSize', node_size);
% h = plot(G_n, 'NodeColor', node_col);
% h = plot(G_n);
h.XData = P_x;
h.YData = P_y;
h.LineWidth = 1.5 * G_n.Edges.Weight;

