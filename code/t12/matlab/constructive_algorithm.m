% 构造性算法实现分叉点构造、线路选型
% 输入：G——最小生成树的邻接矩阵
% (P_x0, P_y0)——负荷坐标
% 输出：G_2——配电网拓扑的邻接矩阵
% (P_i,P_j)——所有节点的坐标
function [G_2, P_i, P_j] = constructive_algorithm(G, P_x0, P_y0)
    global G_1  % 最小生成树的邻接矩阵
    global G_2  % 配电网拓扑的邻接矩阵
    global P_i  % 所有节点的坐标
    global P_j
    global n1   % 负荷数+1
    global n2   % 分叉点数+1
    global cnt  % 计数器，为分叉点编号
    global deg  % 点度数
    global pair % 分叉点与负荷的映射关系
    global Load % 子树的负荷数
    
    G_1 = G;
    deg = zeros(1, n1);
    n2 = cnt_bran_node();      % 计数分叉点
    
    % 节点总数为(n1+n2-1)
    G_2 = zeros(n1 + n2 - 1);
    P_i = zeros(1, n1 + n2 - 1);
    P_j = zeros(1, n1 + n2 - 1);
    P_i(1 : n1) = P_x0(1 : n1);
    P_j(1 : n1) = P_y0(1 : n1);

    cnt = n1;
    pair = zeros(1, n1);

    for i = 1 : n1
        for j = i + 1 : n1
            G_2(i, j) = G_1(i, j);
        end
    end
    G_2 = G_2 + G_2';
    
    % 构造分叉点
    construct_cross_node();
    Load = zeros(1, n1 + n2 - 1);
    % 通过负载数确定线的类型
    judge_line_type();
    % 假设与电源直接相连的为主线
%    set_main_line();
    
%     % 画图
%     figure
%     G_n = graph(G_2);
%     col = zeros(n1 + n2 - 1, 3);
%     for i = 1 : n1
%         col(i, :) = [0 0.4470 0.7410];
%     end
%     for i = n1 + 1 : n1 + n2 -1
%         col(i, :) = [1 0 0];
%     end
%     h = plot(G_n, 'NodeColor', col);  % 返回一个Graphplot对象
%     % 设置节点位置
%     h.XData = P_i;
%     h.YData = P_j;
%     % 设置节点属性
% 
%     % h.NodeCData = col;
%     % 设置线型
%     h.LineWidth = 1.5 * G_n.Edges.Weight;
end

% 计数度数大于1的点
function cnt = cnt_bran_node()
    global G_1
    global n1
    global deg
    for i = 1 : n1
        deg(i) = sum(G_1(i, :));
    end
    bran_node = find(deg(:) > 1);
    cnt = size(bran_node, 1);
end

function [] = construct_cross_node()
    dfs(1, 0);
end

function [] = judge_line_type()
    dfs1(1, 0);
end

function [] = dfs(u, fa)
    global G_1
    global G_2
    global n1
    global cnt
    global P_i
    global P_j
    global deg
    global pair
    
    if deg(u) > 1 && u ~= 1
        % 构造一个新分叉点
        cnt = cnt + 1;
        P_i(cnt) = P_i(u) + rand * 5;
        P_j(cnt) = P_j(u) + rand * 5;
        G_2(cnt, u) = 1;
        G_2(u, cnt) = 1;
        pair(u) = cnt;
        for v = 1 : n1
            if G_1(u, v) == 1
                if pair(v) ~= 0
                    G_2(u, pair(v)) = 0;
                    G_2(pair(v), u) = 0;
                    G_2(cnt, pair(v)) = 1;
                    G_2(pair(v), cnt) = 1;
                else
                    G_2(u, v) = 0;
                    G_2(v, u) = 0;
                    G_2(cnt, v) = 1;
                    G_2(v, cnt) = 1;
                end
            end
        end
    end
    
    for v = 1 : n1
        if G_1(u, v) == 1 && v ~= fa
            dfs(v, u);
        end
    end
end


function [] = dfs1(u, fa)
    global Load
    global G_2
    global n1
    global n2
    if u <= n1 && u ~= 1
        Load(u) = 1;
    end
    for v = 1 : n1 + n2 - 1
        if G_2(u, v) >= 1 && v ~= fa
            dfs1(v, u);
            if Load(v) > 2
                G_2(u, v) = 2;
                G_2(v, u) = 2;
            end
            Load(u) = Load(u) + Load(v);
        end
    end
end


function set_main_line()
    global G_2
    global n1
    global n2
    for v = 1 : n1 + n2 - 1
        if G_2(1, v) >= 1
            G_2(1, v) = 3;
            G_2(v, 1) = 3;
        end
    end
end

