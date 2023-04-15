clear

% 在100*100（km）的区域内随机均匀生成负荷点
% n = 25;
% P_x0 = zeros(1, n);
% P_y0 = zeros(1, n);
% for i = 1 : n
%     P_x0(i) = 100 * rand;
%     P_y0(i) = 100 * rand;
% end
% scatter(P_x0, P_y0, 10, 'filled');
% save('P_xy2.mat', 'P_x0', 'P_y0')

% 节点需求区间为[20,100]
n = 50;
dem = zeros(1, 50);
for i = 1 : n
    dem(i) = rand * 100;
end









