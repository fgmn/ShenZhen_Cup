

clear
global P_x
global P_y
global G_1
global n
global n1
global cost_line
global cost_switch
load('final_graph');
P_x = P_i;
P_y = P_j;
G_1 = G_2;
n = size(P_i, 2);
n1 = 50;
% 线路单价
cost_line = [0 188.6 239.4 325.7];
% 开关单价
cost_switch = [2.6 56.8];


% 求解器
% 无约束极值问题
[x, fval] = fminunc(@f1, rand(2 * (n - n1), 1) - 0.5);
fval0 = f1(zeros(2 * (n - n1), 1));
% fval,x


% 可视化
for i = n1 + 1 : n
    P_x(i) = P_x(i) + x(2 * (i - n1) - 1);
    P_y(i) = P_y(i) + x(2 * (i - n1));
end
figure
G_n = graph(G_1);
col = zeros(n, 3);
for i = 1 : n1
    col(i, :) = [0 0.4470 0.7410];
end
for i = n1 + 1 : n
    col(i, :) = [1 0 0];
end
h = plot(G_n, 'NodeColor', col);
h.XData = P_x;
h.YData = P_y;
h.LineWidth = 1.5 * G_n.Edges.Weight;


function cost = f1(x)
    global n
    global n1
    delta_x = zeros(n - n1);
    delta_y = zeros(n - n1);
    for i = 1 : n - n1
        delta_x(i) = x(2 * i - 1);
        delta_y(i) = x(2 * i);
    end
    cost = f(delta_x, delta_y);
end

% 评价函数
function cost = f(delta_x, delta_y)
	global P_x
    global P_y
    global G_1
    global n
    global n1
    global cost_line
    cost = 0;
    for i = n1 + 1 : n
        P_x(i) = P_x(i) + delta_x(i - n1);
        P_y(i) = P_y(i) + delta_y(i - n1);
    end
    for i = 1 : n
        for j = i + 1 : n
            if G_1(i, j) >= 1
                cost = cost + dis(i, j) * cost_line(G_1(i, j) + 1);
            end
        end
    end
    for i = n1 + 1 : n
        P_x(i) = P_x(i) - delta_x(i - n1);
        P_y(i) = P_y(i) - delta_y(i - n1);
    end
end

% 平面距离函数
function d = dis(i, j)
	global P_x
    global P_y
    d = sqrt((P_x(i) - P_x(j))^2 + (P_y(i) - P_y(j))^2);
end






