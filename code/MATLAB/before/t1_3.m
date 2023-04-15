

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

% GA
w = 3000; % 种群的个数
g = 10000; % 进化代数
rand('state', sum(clock));  % 初始化随机数发生器

% 编码长度
n0 = 2 * (n - n1);

% 获取初始种群
for k = 1 : w
    J(k, :) = rand(n0, 1) * 100 - 50;
end

for k = 1 : g   % 进化轮数
    A = J; % J: 父代 A: 交叉遗传产生的子代 B：从A变异而来的子代
    c = randperm(w);

    % 交叉（融合最优解）
    for i = 1 : 2 : w
        F = 1 + floor((n0 - 1) * rand);  % [1, n0-1]
        tmp = A(c(i), [F + 1 : n0]);
        A(c(i), [F + 1 : n0]) = A(c(i + 1), [F + 1 : n0]);
        A(c(i + 1), [F + 1 : n0]) = tmp;
    end
    
    % 变异
    by = [];
    while ~length(by)
        by = find(rand(1, w) < 0.95);
    end
    B = A(by, :);
    for i = 1 : length(by)
        bw = 1 + floor(n0 * rand);
        B(i, bw) = rand * 100 - 50;
    end
    
    G = [J; A; B];
    N = size(G, 1);
    
    % 优胜略汰
    Cost = zeros(1, N);
    for i = 1 : N
        Cost(i) = f1(G(i, :));
    end
    [Val, g_2] = sort(Cost);
    g_2 = g_2(1 : w);
    G_2 = G(g_2, :);
    J = G_2;    % 产生下一代
    disp(strcat('进化代数：', int2str(k), '； 当前最优为  ',int2str(Val(1))));
end

x = J(1, :);
fval = Val(1);

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






