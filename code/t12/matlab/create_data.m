clear,clc;
center_num = 5;   %簇的数量
point_each = 10;  %每个簇点的数目
r = 100;           %簇的最大半径
center_point = floor( r * rand(center_num, 2) );  % 簇的中心点
point_delta = 10 * 2 * ( rand(point_each * center_num, 2) - ones(point_each * center_num, 2) );     % 点相对中心点的偏移量
point = [];
for i = 1:5
    for j = 1:10
        point = [point;(center_point(i,:) +point_delta(j+(i-1)*5,:))];
    end
end

xlswrite('test_data_create.xlsx',point);
