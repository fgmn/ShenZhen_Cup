
clear all


global G
global p
global r
global r_std
global r_outer
global ncp
global fa_
global is_optimized
global cost_add
global cost_main_line
global cost_switch
global expand_price
global pow
global P

load('t3_input.mat');

cost_main_line = 325.7;
cost_switch = 56.8;
expand_price = 10;
cost_add = 0;

r_std = r;
cnt_cont = 0;
cont_line = zeros(100, 2);

clac_basics(1);
clac_basics(2);

% 计算网络负荷需求之和
P = zeros(2, 1);
for i = 1 : 2
    for j = 1 : size(pow{i}, 1)
        P(i) = P(i) + pow{i}(j) * r{i}(j);
    end
end

for t = 1 : 100
    cost_add = 0;
    clac_optimization(1);
    clac_optimization(2);
    
    for i = 1 : cnt_cont
        u = cont_line(i, 1); v = cont_line(i, 2);
        dis_uv = sqrt((p{1}(u, 1) - p{2}(v, 1))^2 + (p{1}(u, 2) - p{2}(v, 2))^2);
        cost_add = cost_add + cost_main_line * dis_uv + cost_switch;
    end
    
    [min_r(1), m(1)] = min(r{1});
    [min_r(2), m(2)] = min(r{2});
    disp(strcat('第', num2str(t), '轮方案设计花费为', num2str(cost_add), '，此时最低用电可靠性为', num2str(min(min_r))))
    X(t) = cost_add;
    Y(t) = min(min_r);
    
    % 1.两最低点均已优化，依据贪心设置原则无法继续优化，算法结束
    if is_optimized{1}(m(1)) + is_optimized{2}(m(2)) > 0
        break
    end
    % 2.单一最低点已优化，继续优化另一网络
    % todo
    % 3.最低点均未优化
    % 3.1 存在联络线，增加拓展供电方案
    if ncp{1}(m(1)) + ncp{2}(m(2)) > 0
        if ncp{1}(m(1)) > 0
            is_optimized{1}(m(1)) = 1;
        end
        if ncp{2}(m(2)) > 0
            is_optimized{2}(m(2)) = 1;
        end
        continue;
    end
    % 3.2 调整联络线
    
    % 搜索最低成本的联络线方案
    disp(m)
    if fa_{1}(m(1)) == 1 || fa_{2}(m(2)) == 1
        break
    end
    to_select1 = get_ancestors(m(1), 1);
    to_select2 = get_ancestors(m(2), 2);
    sz1 = size(to_select1, 2);
    sz2 = size(to_select2, 2);
    to_select_edge = zeros(sz1 * sz2, 3);
    for i = 1 : sz1
        for j = 1 : sz2
            u = to_select1(i); v = to_select2(j);
            dis_ij = sqrt((p{1}(u, 1) - p{2}(v, 1))^2 + (p{1}(u, 2) - p{2}(v, 2))^2);
            to_select_edge((i - 1) * sz2 + j, :) = [u, v, dis_ij]; 
        end
    end
    [~, one] = min(to_select_edge(:, 3));
    cont_1 = to_select_edge(one, 1); cont_2 = to_select_edge(one, 2);
%     cont_1 = fa_{1}(m(1)); cont_2 = fa_{2}(m(2));

    % 3.2.1 联络点上跳
    kid_ncp = find_kid_ncp(cont_1, fa_{1}(cont_1), 1);
    if kid_ncp > 0
        tmp = find(cont_line(1 : cnt_cont, 1) == kid_ncp);
        disp(strcat('jump in tree A: ', num2str(cont_line(tmp, 1)), '->', num2str(cont_1)));
        cont_line(tmp, 1) = cont_1;
        c2 = cont_line(tmp, 2);
        disp(strcat('get contact line: ', num2str(cont_1), '-', num2str(c2)));
        dis_12 = sqrt((p{1}(cont_1, 1) - p{2}(c2, 1))^2 + (p{1}(cont_1, 2) - p{2}(c2, 2))^2);
        r_outer{1}(cont_1) = r{2}(c2) * (1 - 0.002) * (1 - 0.002 * dis_12);
        r_outer{2}(c2) = r{1}(cont_1) * (1 - 0.002) * (1 - 0.002 * dis_12);
        set_ncp(cont_1, fa_{1}(cont_1), 1, cont_1);
        is_optimized{1}(m(1)) = 1;
        continue;
    end
    kid_ncp = find_kid_ncp(cont_2, fa_{2}(cont_2), 2);
    if kid_ncp > 0
        tmp = find(cont_line(1 : cnt_cont, 2) == kid_ncp);
        disp(strcat('jump in tree B: ', num2str(cont_line(tmp, 2)), '->', num2str(cont_2)));
        cont_line(tmp, 2) = cont_2;
        c1 = cont_line(tmp, 1);
        disp(strcat('get contact line: ', num2str(c1), '-', num2str(cont_2)));
        dis_12 = sqrt((p{1}(c1, 1) - p{2}(cont_2, 1))^2 + (p{1}(c1, 2) - p{2}(cont_2, 2))^2);
        r_outer{1}(c1) = r{2}(cont_2) * (1 - 0.002) * (1 - 0.002 * dis_12);
        r_outer{2}(cont_2) = r{1}(c1) * (1 - 0.002) * (1 - 0.002 * dis_12);
        set_ncp(cont_2, fa_{2}(cont_2), 2, cont_2);
        is_optimized{2}(m(2)) = 1;
        continue;
    end
    
    % 3.2.2 增加联络线
    set_ncp(cont_1, fa_{1}(cont_1), 1, cont_1);
    set_ncp(cont_2, fa_{2}(cont_2), 2, cont_2);
    cnt_cont = cnt_cont + 1;
    cont_line(cnt_cont, :) = [cont_1 cont_2];
    disp(strcat('get contact line: ', num2str(cont_1), '-', num2str(cont_2)));
    dis_12 = sqrt((p{1}(cont_1, 1) - p{2}(cont_2, 1))^2 + (p{1}(cont_1, 2) - p{2}(cont_2, 2))^2);
    r_outer{1}(cont_1) = r{2}(cont_2) * (1 - 0.002) * (1 - 0.002 * dis_12);
    r_outer{2}(cont_2) = r{1}(cont_1) * (1 - 0.002) * (1 - 0.002 * dis_12);
    is_optimized{1}(m(1)) = 1; is_optimized{2}(m(2)) = 1;
end

save('cont_line', 'cont_line', 'cnt_cont');
X = X(:);
Y = Y(:);
save('XY', 'X', 'Y');

% 搜索子树中的联络点，至多存在一个
function kid_ncp = find_kid_ncp(u, fa, k)
    global G
    global ncp
    n = size(G{k}, 1);
    kid_ncp = 0;
    for v = 1 : n
        if G{k}(u, v) >= 1 && v ~= fa
            if ncp{k}(v) > 0
                kid_ncp = v;
                return;
            end
            kid_ncp = max(kid_ncp, find_kid_ncp(v, u, k));
        end
    end
end

% 获取祖先分叉点
function ancestors = get_ancestors(u, k)
    global fa_
    cnt = 0;
    fa = fa_{k}(u);
    while fa ~= 1
        cnt = cnt + 1;
        ancestors(cnt) = fa;
        u = fa;
        fa = fa_{k}(u);
    end
%     cnt = cnt + 1;
%     ancestors(cnt) = 1;
end

% 设置最近联络点
function [] = set_ncp(u, fa, k, c)
    global G
    global ncp
    n = size(G{k}, 1);
    ncp{k}(u) = c;
    for v = 1 : n
        if G{k}(u, v) >= 1 && v ~= fa
            set_ncp(v, u, k, c);
        end
    end
end

% 计算基础用电可靠性
function [] = clac_basics(k)
    global G
    global p
    global r
    n = size(G{k}, 1);
    r{k}(1) = 1 - 0.005;
    for v = 1 : n
        if G{k}(1, v) >= 1
            dfs(v, 1, k);
        end
    end
end

function [] = dfs(u, fa, k)
    global G
    global p
    global r
    global fa_
    
    n = size(G{k}, 1);
    fa_{k}(u) = fa;
    dis_ufa = sqrt((p{k}(u, 1) - p{k}(fa, 1))^2 + (p{k}(u, 2) - p{k}(fa, 2))^2);
    r{k}(u) = r{k}(fa) * (1 - 0.005) * (1 - 0.002) * (1 - 0.002 * dis_ufa);
    for v = 1 : n
        if G{k}(u, v) >= 1 && v ~= fa
            dfs(v, u, k);
        end
    end
end

% 计算优化后用电可靠性
function [] = clac_optimization(k)
    global G
    global r
    global r_std
    global r_outer
    global ncp
    global is_optimized
    global cost_add
    global pow
    global expand_price
    global P
    
    n = size(G{k}, 1);
    pow_add = 0;
    for i = 1 : n
        if is_optimized{k}(i) > 0
            r_com = r{k}(i) / r_std{k}(ncp{k}(i));  % 本地线路和拓展线路的公共部分
            r{k}(i) = (r_std{k}(ncp{k}(i)) + r_outer{k}(ncp{k}(i)) - r_std{k}(ncp{k}(i)) * r_outer{k}(ncp{k}(i))) * r_com * (1 - 0.005);
            pow_add = pow_add + (r{k}(i) - r_std{k}(i)) * pow{k}(i);
        end
    end
%     pow_add, 0.1 * P(3 - k)
    pow_add = max([pow_add - 0.1 * P(3 - k), 0]);
    if pow_add > 0.55 * P(3 - k)
        disp('bomb!')
    end
    cost_add = cost_add + pow_add * expand_price;
end




