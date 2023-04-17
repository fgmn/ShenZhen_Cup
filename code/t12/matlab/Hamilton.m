% Single supply and distribution network model
% 输入：(point , k)——聚类点，聚类次数
% 输出：G_1——配电网络拓扑图
% (P_x, P_y)——网络中节点坐标
function [shortest,G] = Hamilton(center)
    size = length(center);
    center
    %dp[1 << 20][27]; // %dp[i][j]表示经过了i对应二进制数的点 到第j-1个点的最短距离
    %1 号点出发到某个点的hamilton路径的最小值
    dist = zeros(size,size);
    for i = 1:size
        for j = 1:size
            dist(i,j) = norm(center(i,:)-center(j,:));

        end
    end
    dist
    dp = Inf*ones(bitshift(1, size),size);

    road = cell(bitshift(1, size),size);
    road{1+1,1} = [1];
    road{1+1,1};
    dp(1+1,0+1) = 0;
    for i = 1:(bitshift(1, size)-1)
        for j = 0:(size-1)
            bitshift(i, -1*j);
            bitand(bitshift(i, -1*j),1);
            if(bitand(bitshift(i, -1*j),1 ) ) %此时的j点是已走点
                for k = 0:(size-1) % 上一次经过的点对应的二进制数是 i ^ 1 << j
                    if( bitxor(i, bitand( bitshift( bitshift(1,j),-1*k) ,1) ) )  %在上一次经过的点中 k必须是经过了的  现在是求把j点加入的最短路径
                        if(dp(i+1,j+1)>dp(bitxor(i ,bitshift(1,j) )+1,k+1) + dist(k+1,j+1))
                            road{i+1,j+1} = road{bitxor(i ,bitshift(1,j))+1,k+1};
                            road{i+1,j+1} = [road{i+1,j+1},j+1];
                        end
                        dp(i+1,j+1) = min( dp(i+1,j+1), dp(bitxor(i ,bitshift(1,j) )+1,k+1) + dist(k+1,j+1));

                    end
                end
            end
        end
    end
    dp
    for i = 1:bitshift(1, size)
        road{i,:}
    end
    result = min(dp(bitshift(1,size)- 1 +1, :));
    result_index = find(dp(bitshift(1,size)- 1 +1, :)==result);
    shortest = road{bitshift(1,size)- 1+1,result_index}
    x = center(:,1);
    y = center(:,2);

    A = zeros(size,size);
    for i = 1:size-1
        A(shortest(i),shortest(i+1)) =  dist(shortest(i),shortest(i+1));
        %A(shortest(i+1),shortest(i)) =  dist(shortest(i+1),shortest(i));
    end

    G = digraph(A);
end


function count = find_one(bin)
    count = 0;

    while (bin ~=0 )
        if (bitand(bin,1) == 1)

            count = count+1;

        end
        bin = bitshift(bin,-1);    
    end
end



