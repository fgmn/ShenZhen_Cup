

% ��ȡ��С������
% ���룺(P_x0,P_y0)�������нڵ㣨������Դ��������
% �����G������С���������ڽӾ���
function G = get_MST(P_x0, P_y0)
    global fa           % ���鼯
    global W            % ŷ����þ���
    global P_ij         % W��Ӧ���߶ζ˵�
    global G            % ��С���������ڽӾ���
    global e            % ��С�������ı߼�
    global n1           % ������+1
    
    n1 = size(P_x0, 2);
    e = zeros(2, n1 - 1);
    G = zeros(n1);                    
    P_ij = zeros(2, n1 * (n1 - 1) / 2);
    W = zeros(1, n1 * (n1 - 1) / 2);   
    fa = zeros(1, n1);                
    for i = 1 : n1
        fa(i) = i;
    end
    
    cnt0 = 1;
    for i = 1 : n1
        for j = i + 1 : n1
            P_ij(1, cnt0) = i;
            P_ij(2, cnt0) = j;
            W(cnt0) = sqrt((P_x0(i) - P_x0(j))^2 + (P_y0(i) - P_y0(j))^2);
            cnt0 = cnt0 + 1;
        end
    end
    % kruskal�����С������
    get_mst();
    G = G + G';
    
%     % ��ͼ
%     figure
%     G_2 = graph(G);
%     % G_2 = graph(e(1, :), e(2, :));
%     h = plot(G_2);  
%     h.XData = P_x0;
%     h.YData = P_y0;
end

function [] = get_mst()
    global G
    global P_ij
    global W
    global fa
    global n1
    global e
    [W, iw] = sort(W);
    P_ij(:, :) = P_ij(:, iw);
    cnt = 0;
    for i = 1 : n1 * (n1 - 1) / 2
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
            if cnt >= n1 - 1
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
