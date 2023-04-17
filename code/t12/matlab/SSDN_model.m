
% Single supply and distribution network model
% 输入：(P_x0, P_y0)——负荷以及电源坐标，电源为1号节点
% 输出：G_1——配电网络拓扑图
% (P_x, P_y)——网络中节点坐标
function [G_3, P_x, P_y, fval, r] = SSDN_model(P_x0, P_y0)
    % global将变量放入全局工作区，其他部分可同样通过global获取该变量
    global P_x      % 所有节点坐标
    global P_y
    global G_3      % 配电网拓扑的邻接矩阵
    global e_3      % 配电网拓扑的边集
    global cnt_e
    global n        % 节点总数
    global n1       % 负荷数+1
    global cost_line    % 线路单价
    global cost_switch  % 开关单价
    global r            % 用户用电可靠性

    
    G = get_MST(P_x0, P_y0);
    [G_3, P_x, P_y] = constructive_algorithm(G, P_x0, P_y0);    % 增加构造算法构造的分叉点
    
    n = size(P_x, 2);
    
    % 预处理获取边集，优化算法效率
    e_3 = zeros(n * (n - 1) / 2, 3);
    cnt_e = 0;
    for i = 1 : n
        for j = i + 1 : n
            if G_3(i, j) >= 1
                cnt_e = cnt_e + 1;
                e_3(cnt_e, 1) = i;
                e_3(cnt_e, 2) = j;
                e_3(cnt_e, 3) = G_3(i, j);
            end
        end
    end
%     cnt_e

    cost_line = [0 188.6 239.4 325.7];
    cost_switch = [2.6 56.8];


    % 求解器
    % 无约束极值问题
    n;
    n1;
    if(n-n1~=0)
        [x, fval] = fminunc(@f1, rand(2 * (n - n1), 1) - 0.5);
    end

    fval = f1(zeros(2 * (n - n1), 1));
    fval = fval + cost_switch * [n1 - 1; n - n1];
    % fval,x
    for i = n1 + 1 : n
        P_x(i) = P_x(i) + x(2 * (i - n1) - 1);
        P_y(i) = P_y(i) + x(2 * (i - n1));
    end
    
    r = zeros(n, 1);
    clac_power_reliability();
    
%     % 可视化
%     figure
%     G_n = graph(G_3);
%     col = zeros(n, 3);
%     for i = 1 : n1
%         col(i, :) = [0 0.4470 0.7410];
%     end
%     for i = n1 + 1 : n
%         col(i, :) = [1 0 0];
%     end
%     h = plot(G_n, 'NodeColor', col);
%     h.XData = P_x;
%     h.YData = P_y;
%     h.LineWidth = 1.5 * G_n.Edges.Weight;
end

% function cost = f1(x)
%     global n
%     global n1
%     delta_x = zeros(n - n1);
%     delta_y = zeros(n - n1);
%     for i = 1 : n - n1
%         delta_x(i) = x(2 * i - 1);
%         delta_y(i) = x(2 * i);
%     end
%     cost = f(delta_x, delta_y);
% end

% 评价函数
function cost = f1(x)
	global P_x
    global P_y
    global e_3
    global cnt_e
    global n
    global n1
    global cost_line
    cost = 0;
    delta_x = zeros(n - n1);
    delta_y = zeros(n - n1);
    for i = 1 : n - n1
        delta_x(i) = x(2 * i - 1);
        delta_y(i) = x(2 * i);
    end
    for i = n1 + 1 : n
        P_x(i) = P_x(i) + delta_x(i - n1);
        P_y(i) = P_y(i) + delta_y(i - n1);
    end
%     for i = 1 : n
%         for j = i + 1 : n
%             if G_3(i, j) >= 1
%                 dis_ij = sqrt((P_x(i) - P_x(j))^2 + (P_y(i) - P_y(j))^2);
%                 cost = cost + dis_ij * cost_line(G_3(i, j) + 1);
%             end
%         end
%     end
    for i = 1 : cnt_e
        dis_ij = sqrt((P_x(e_3(i, 1)) - P_x(e_3(i, 2)))^2 + (P_y(e_3(i, 1)) - P_y(e_3(i, 2)))^2);
        cost = cost + dis_ij * cost_line(e_3(i, 3) + 1);
    end
    for i = n1 + 1 : n
        P_x(i) = P_x(i) - delta_x(i - n1);
        P_y(i) = P_y(i) - delta_y(i - n1);
    end
end

% 计算用户用电可靠性
function [] = clac_power_reliability()
    global r
    global G_3
    global n
    r(1) = 1 - 0.005;
    for v = 1 : n
        if G_3(1, v) >= 1
            dfs2(v, 1);
        end
    end
end

function [] = dfs2(u, fa)
    global r
    global G_3
    global n
	global P_x
    global P_y
    dis_ufa = sqrt((P_x(u) - P_x(fa))^2 + (P_y(u) - P_y(fa))^2);
    r(u) = r(fa) * (1 - 0.005) * (1 - 0.002) * (1 - 0.002 * dis_ufa);
    for v = 1 : n
        if G_3(u, v) >= 1 && v ~= fa
            dfs2(v, u);
        end
    end    
end