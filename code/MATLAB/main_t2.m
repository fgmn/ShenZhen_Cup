

clear all
close all

global k
global x_M
global y_M
global x_T1
global y_T1
global x_T2
global y_T2
global n_leaf
global P_x0
global P_y0
global P1
global P2
global P3
global cnt_P1
global cnt_P2
global cnt_P3

load('P_xy.mat');
% 生成两个独立电源,(rand*10)
x_K1 = 75 + (-2.2116);
y_K1 = 75 + 0.8243;
x_K2 = 25 + 2.8620;
y_K2 = 25 + 2.2309;


n_leaf = size(P_x0, 2);
P1 = zeros(1, n_leaf);
P2 = zeros(1, n_leaf);
P3 = zeros(1, n_leaf);

k = (y_K2 - y_K1) / (x_K2 - x_K1);
x_M = (x_K1 + x_K2) / 2;
y_M = (y_K1 + y_K2) / 2;

t = 0;
set_t(t);

% 二分法确定t值
alpha = 10;
L = 0; R = 100;
ret = 0;
while ret ~= alpha
    t = (L + R) / 2;
    ret = check(t);
    if ret > alpha
        R = t;
    elseif ret < alpha
        L = t;
    end
end
% t, cnt_P1, cnt_P2, cnt_P3
% P1, P2, P3
% t

% % 可视化
hold on
plot(P_x0, P_y0, 'ro')
plot(P_x0(P3(1 : cnt_P3)), P_y0(P3(1 : cnt_P3)), 'go')
plot(x_K1, y_K1, 'bo')
plot(x_K2, y_K2, 'bo')
plot(x_M, y_M, 'bo')
plot([x_K1, x_K2], [y_K1, y_K2], 'b');
plot([x_T1 - 75, x_T1 + 75], [y_T1 + 1 / k * 75, y_T1 - 1 / k * 75], 'b')
plot([x_T2 - 75, x_T2 + 75], [y_T2 + 1 / k * 75, y_T2 - 1 / k * 75], 'b')

% 结合问题一模型求解最优二分类
cost_best = inf;
for i = 0 : bitshift(2, alpha - 1) - 1
    s1 = zeros(1, alpha);
    s2 = zeros(1, alpha);
    cnt_s1 = 0; cnt_s2 = 0;
    for j = 0 : alpha - 1
        if bitand(bitshift(i, -j), 1) == 1
            cnt_s1 = cnt_s1 + 1;
            s1(cnt_s1) = P3(j + 1);
        else
            cnt_s2 = cnt_s2 + 1;
            s2(cnt_s2) = P3(j + 1);
        end
    end
    P1(cnt_P1 + 1 : cnt_P1 + cnt_s1) = s1(1 : cnt_s1);
    P2(cnt_P2 + 1 : cnt_P2 + cnt_s2) = s2(1 : cnt_s2);   
    P1 = int32(P1);
    P2 = int32(P2);
    x_s1(1) = x_K1; y_s1(1) = y_K1;
    x_s2(1) = x_K2; y_s2(1) = y_K2;
    x_s1(2 : cnt_P1 + cnt_s1 + 1) = P_x0(P1(1 : cnt_P1 + cnt_s1));
    y_s1(2 : cnt_P1 + cnt_s1 + 1) = P_y0(P1(1 : cnt_P1 + cnt_s1));
    x_s2(2 : cnt_P2 + cnt_s2 + 1) = P_x0(P2(1 : cnt_P2 + cnt_s2));
    y_s2(2 : cnt_P2 + cnt_s2 + 1) = P_y0(P2(1 : cnt_P2 + cnt_s2));
    [G_3_s1, P_x_s1, P_y_s1, fval_s1, r_s1] = SSDN_model(x_s1, y_s1);
    [G_3_s2, P_x_s2, P_y_s2, fval_s2, r_s2] = SSDN_model(x_s2, y_s2);
    disp(strcat("第", int2str(i + 1), "个状态花费为", num2str(fval_s1 + fval_s2), ",当前最优为", num2str(cost_best)))
    % 更新最优解
    if fval_s1 + fval_s2 < cost_best
        cost_best = fval_s1 + fval_s2;
        G_3_s1_best = G_3_s1;
        G_3_s2_best = G_3_s2;
        P_x_s1_best = P_x_s1; P_y_s1_best = P_y_s1;
        P_x_s2_best = P_x_s2; P_y_s2_best = P_y_s2;
        r_s1_best = r_s1;
        r_s2_best = r_s2;
    end
end
save('t2_best', 'cost_best', 'G_3_s1_best', 'G_3_s2_best', 'P_x_s1_best', 'P_x_s2_best', 'P_y_s1_best', 'P_y_s2_best', 'r_s1_best', 'r_s2_best');

function ret = check(t)
    global n_leaf
    global P_x0
    global P_y0
    global P1
    global P2
    global P3
    global cnt_P1
    global cnt_P2
    global cnt_P3
    global x_T1
    global y_T1
    global x_T2
    global y_T2
    global k
    cnt_P1 = 0; cnt_P2 = 0; cnt_P3 = 0;
    P1(:) = 0; P2(:) = 0; P3(:) = 0;
    set_t(t);
    for i = 1 : n_leaf
        if P_y0(i) - y_T1 + 1 / k * (P_x0(i) - x_T1) > 0 % f_1(P_x0(i), P_y0(i)) > 0
            cnt_P1 = cnt_P1 + 1;
            P1(cnt_P1) = i;
        elseif P_y0(i) - y_T2 + 1 / k * (P_x0(i) - x_T2) < 0 % f_2(P_x0(i), P_y0(i)) < 0
            cnt_P2 = cnt_P2 + 1;
            P2(cnt_P2) = i;
        else % if f_1(P_x0(i), P_y0(i)) * f_2(P_x0(i), P_y0(i)) < 0
            cnt_P3 = cnt_P3 + 1;
            P3(cnt_P3) = i;
        end
    end
    ret = cnt_P3;
end

function [] = set_t(t)
    global k
    global x_M
    global y_M
    global x_T1
    global x_T2
    global y_T1
    global y_T2
    sign = 1;
    if k < 0
        sign = -1;
    end
    % 保证直线l_1在上方
    x_T1 = x_M + sign * t / sqrt(k ^ 2 + 1);
    y_T1 = y_M + sign * t * k / sqrt(k ^ 2 + 1);
    x_T2 = x_M - sign * t / sqrt(k ^ 2 + 1);
    y_T2 = y_M - sign * t * k / sqrt(k ^ 2 + 1);
end

% function res = f_1(x, y)
%     global x_T1
%     global y_T1
%     global k
%     res = y - y_T1 + 1 / k * (x - x_T1);
% end
% 
% function res = f_2(x, y)
%     global x_T2
%     global y_T2
%     global k
%     res = y - y_T2 + 1 / k * (x - x_T2);
% end


