% Single supply and distribution network model
% 输入：(point , k)——聚类点，聚类次数
% 输出：G_1——配电网络拓扑图
% (P_x, P_y)——网络中节点坐标
function [center,group] = k_means(point , k)
    
    count = 100000;  % 定义最大循环次数
    [N,~] = size(point);
    center = point(1:k,:);  % 令前k个点为初始的聚类中心
    group=cell(k);
    distance_square = zeros(N,k);
    while count~=0
        for i = 1:k
            distance_square(:,i) = sum((point - repmat(center(i,:),N,1)).^2,2);
            group{i} = [];
        end  % 计算到每个点到各个聚类中心的距离

        for i = 1:N
            minposition = find(distance_square(i,:)==min(distance_square(i,:)));
            group{minposition} =  [group{minposition};point(i,:)];
        end  % 建立第一次分类后的分类点集

        for i = 1:k
            center_New(i,:) = mean(group{i},1);
        end  % 计算新的聚类中心

        if sym(sum((center_New - center).^2)) == 0
            break
        else
            center = center_New;
        end  % 如果中心未改变则跳出循环

        count = count-1;
    end
end