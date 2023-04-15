

clear

load('P_xy.mat');

n = 50;
a = zeros(n, 2);
for i = 1 : n
    a(i, 1) = P_x0(i);
    a(i, 2) = P_y0(i);
end
y = pdist(a, 'seuclidean'); % 使用欧式距离作为样本之间相似度度量
yc = squareform(y);
z = linkage(y, 'weighted'); % 使用赋权平均距离作为类之间相似度度量
% dendrogram(z);
T = cluster(z, 'maxclust', 2);

col = zeros(n, 3);
Col = [0 0 1; 1 0 0];
for i = 1 : 2
    tm = find(T == i);
    tm = reshape(tm, 1, length(tm));
    for j = 1 : size(tm, 2)
        col(tm(j), :) = Col(i, :);
    end
    fprintf('第 %d 类的有 %s\n', i, int2str(tm));
end


G = zeros(50);
figure
G_n = graph(G);
h = plot(G_n, 'NodeColor', col);  % 返回一个Graphplot对象
h.XData = P_x0;
h.YData = P_y0;





