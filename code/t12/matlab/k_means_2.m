clear,clc;

k = 2;  % 输入聚类组数
%data = importdata('test_data_create.xlsx');
data_ = importdata('load_demo.xlsx');
data = data_.qh;
data = [data;data_.yh];
[center,group_] = k_means(data,2);
center
group = cell(k,1)
for i = 1:k
    group{i,1} = group_{i,1}
end
group{i,1}(:,1)
hold on

for i = 1:k
    plot(group{i,1}(:,1),group{i,1}(:,2),'.','Markersize',15,'color',[rand rand rand]);

    kn = boundary(group{i,1}(:,1),group{i,1}(:,2),0.1);

    if isempty(kn)
        plot(group{i,1}(:,1),group{i,1}(:,2));
    else
        plot(group{i,1}(kn,1),group{i,1}(kn,2));
    end
    plot(center(:,1),center(:,2),'k+');
end  % 绘图
xlswrite('part.xlsx',center,'center');

for i = 1:k
    xlswrite('part.xlsx',group{i,1},['group',num2str(i)]);
end
