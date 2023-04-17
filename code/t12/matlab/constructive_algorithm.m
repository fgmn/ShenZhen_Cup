% �������㷨ʵ�ֲַ�㹹�졢��·ѡ��
% ���룺G������С���������ڽӾ���
% (P_x0, P_y0)������������
% �����G_2������������˵��ڽӾ���
% (P_i,P_j)�������нڵ������
function [G_2, P_i, P_j] = constructive_algorithm(G, P_x0, P_y0)
    global G_1  % ��С���������ڽӾ���
    global G_2  % ��������˵��ڽӾ���
    global P_i  % ���нڵ������
    global P_j
    global n1   % ������+1
    global n2   % �ֲ����+1
    global cnt  % ��������Ϊ�ֲ����
    global deg  % �����
    global pair % �ֲ���븺�ɵ�ӳ���ϵ
    global Load % �����ĸ�����
    
    G_1 = G;
    deg = zeros(1, n1);
    n2 = cnt_bran_node();      % �����ֲ��
    
    % �ڵ�����Ϊ(n1+n2-1)
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
    
    % ����ֲ��
    construct_cross_node();
    Load = zeros(1, n1 + n2 - 1);
    % ͨ��������ȷ���ߵ�����
    judge_line_type();
    % �������Դֱ��������Ϊ����
%    set_main_line();
    
%     % ��ͼ
%     figure
%     G_n = graph(G_2);
%     col = zeros(n1 + n2 - 1, 3);
%     for i = 1 : n1
%         col(i, :) = [0 0.4470 0.7410];
%     end
%     for i = n1 + 1 : n1 + n2 -1
%         col(i, :) = [1 0 0];
%     end
%     h = plot(G_n, 'NodeColor', col);  % ����һ��Graphplot����
%     % ���ýڵ�λ��
%     h.XData = P_i;
%     h.YData = P_j;
%     % ���ýڵ�����
% 
%     % h.NodeCData = col;
%     % ��������
%     h.LineWidth = 1.5 * G_n.Edges.Weight;
end

% ������������1�ĵ�
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
        % ����һ���·ֲ��
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

