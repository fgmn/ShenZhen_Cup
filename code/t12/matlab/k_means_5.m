clear,clc;

k = 5;  % 输入聚类组数
data_ = importdata('part.xlsx');
dataA = data_.group1
dataB = data_.group2

pointA = dataA;   %各坐标
pointB = dataB;   %各坐标
[center1,groupA] = k_means(pointA,k);
[center2,groupB] = k_means(pointB,k);

hold on
for i = 1:k
    plot(groupA{i,1}(:,1),groupA{i,1}(:,2),'.','Markersize',15,'color',[rand rand rand]);

    kn = boundary(groupA{i,1}(:,1),groupA{i,1}(:,2),0.1);

    if isempty(kn)
        plot(groupA{i,1}(:,1),groupA{i,1}(:,2));
    else
        plot(groupA{i,1}(kn,1),groupA{i,1}(kn,2));
    end
    plot(center1(:,1),center1(:,2),'k+');
end  % 绘图
xlswrite('centerA.xlsx',center1,'center');

for i = 1:k
    xlswrite('centerA.xlsx',groupA{i,1},['groupA',num2str(i)]);
end


for i = 1:k
    plot(groupB{i,1}(:,1),groupB{i,1}(:,2),'.','Markersize',15,'color',[rand rand rand]);

    kn = boundary(groupB{i,1}(:,1),groupB{i,1}(:,2),0.1);

    if isempty(kn)
        plot(groupB{i,1}(:,1),groupB{i,1}(:,2));
    else
        plot(groupB{i,1}(kn,1),groupB{i,1}(kn,2));
    end
    plot(center2(:,1),center2(:,2),'k+');
end  % 绘图
xlswrite('centerB.xlsx',center2,'center');

for i = 1:k
    xlswrite('centerB.xlsx',groupB{i,1},['groupB',num2str(i)]);
end