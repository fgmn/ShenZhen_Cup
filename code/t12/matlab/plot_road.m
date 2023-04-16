source1 = [-24602.492188,-11826.172852];
source2 = [-25531.816406,-13508.734375];
data1 = importdata('centerA.xlsx');
data2 = importdata('centerB.xlsx');

center1 = data1.center
center2 = data2.center


center1 = [source1;center1];
center2 = [source2;center2];
xlswrite('road.xlsx',center1,'center1');
xlswrite('road.xlsx',center2,'center2');
%center = [0,0;0,1;0,2];
size1 = length(center1);
size2 = length(center2);


[shortest1,G1] = Hamilton(center1);
[shortest2,G2] = Hamilton(center2);
xlswrite('road.xlsx',shortest1,'shortest1');
xlswrite('road.xlsx',shortest2,'shortest2');

x1 = center1(:,1);
y1 = center1(:,2);
plot(G1,'XData',x1,'YData',y1);
hold on;
x2 = center2(:,1);
y2 = center2(:,2);
plot(G1,'XData',x2,'YData',y2);
hold on;
%for i = 1:k
 %   xlswrite('center.xlsx',group{i},['group',num2str(i)]);
%end
