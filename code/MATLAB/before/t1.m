
clear

load('P_xy.mat');
global fa
global P_ij
global W
global G
global P_x
global P_y
global n
global e

P_x = P_x0;
P_y = P_y0;

n = 50;
e = zeros(2, n - 1);
G = zeros(n); % 最小生成树
P_ij = zeros(2, n * (n - 1) / 2);
W = zeros(1, n * (n - 1) / 2);  % 两点距离
fa = zeros(1, n);
for i = 1 : n
    fa(i) = i;
end

cnt0 = 1;
for i = 1 : n
    for j = i + 1 : n
        P_ij(1, cnt0) = i;
        P_ij(2, cnt0) = j;
        W(cnt0) = dis(i, j);
        cnt0 = cnt0 + 1;
    end
end
% kruskal求解最小生成树
get_mst();
G = G + G';

% 画图
figure
G_2 = graph(G);
% G_2 = graph(e(1, :), e(2, :));
h = plot(G_2);  
h.XData = P_x;
h.YData = P_y;

function d = dis(i, j)
	global P_x
    global P_y
%     P_x(i)
    d = sqrt((P_x(i) - P_x(j))^2 + (P_y(i) - P_y(j))^2);
end

function [] = get_mst()
    global G
    global P_ij
    global W
    global fa
    global n
    global e
    [W, iw] = sort(W);
    P_ij(:, :) = P_ij(:, iw);
    cnt = 0;
    for i = 1 : n * (n - 1) / 2
        u = P_ij(1, i);
        v = P_ij(2, i);
        fx = Find(u);
        fy = Find(v);
        if fx ~= fy
            fa(fx) = fy;
            G(u, v) = 1;
            cnt = cnt + 1;
            e(1, cnt) = u;
            e(2, cnt) = v;
            if cnt >= n - 1
                break;
            end
        end
    end
end

function res = Find(x)
    global fa
    if x == fa(x)
        res = x;
    else
        fa(x) = Find(fa(x));
        res = fa(x);
    end
end



