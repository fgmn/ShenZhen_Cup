clear,clc;
data=importdata('前25.xlsx');

ID = data.data;
data.textdata(1,:) = [];
name = data.textdata(:,4);
type = data.textdata(:,5);
content = data.textdata(:,6);
front = data.textdata(:,7);
back = data.textdata(:,8);
XY = data.textdata(:,9);
size_all = length(ID);

xy = cell(size_all,1);
line = [];
swt = [];
load = [];
load_c = [];
for i = 1:size_all
    tuple = strsplit(XY{i},'/');
    s = length(tuple);
    for j = 1:(s-1)
        p = strsplit(tuple{j});
        px = str2num(p{1});
        py = str2num(p{2});
        
        xy{i} = [xy{i};px,py];
    end
end

for i = 1:size_all
    if strcmp(type{i}, '导线')
        line = [line; ID(i)];
        plot(xy{i}(:,1),xy{i}(:,2),'color',[1 0 1]);
        hold on;
        elseif strcmp(type{i},'开关') 
            swt = [swt;ID(i) ];
            plot(xy{i}(1),xy{i}(2),'+','Markersize',10,'color',[1 0.5 1]);

        elseif strcmp(type{i},'变压器')
            
            plot(xy{i}(1),xy{i}(2),'.','Markersize',15,'color',[1 0.7 1]);
            load = [load;xy{i}(1),xy{i}(2)];
            c = str2num(content{i}(1:6));
            load_c = [load_c;c]

    end
    
end
plot(-25531.816406,-13508.734375,'o','Markersize',20,'color',[0 0 0]);
xlswrite('load_demo.xlsx',[load,load_c],'qh');


%indexOf(ID,102)；


function index = indexOf(ID,id)
index = find(ID==id);
end


