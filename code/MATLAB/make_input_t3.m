
clear all

load('test_data.mat');
load('t2_best.mat');
G(1) = {G_3_s1_best};
G(2) = {G_3_s2_best};
p(1) = {[P_x_s1_best(:), P_y_s1_best(:)]};
p(2) = {[P_x_s2_best(:), P_y_s2_best(:)]};
r(1) = {r_s1_best};
r(2) = {r_s2_best};
% nearest contact point
ncp(1) = {zeros(size(r{1}, 1), 1)};
ncp(2) = {zeros(size(r{2}, 1), 1)};

fa_(1) = {zeros(size(r{1}, 1), 1)};
fa_(2) = {zeros(size(r{2}, 1), 1)};
is_optimized(1) = {logical(zeros(size(r{1}, 1), 1))};
is_optimized(2) = {logical(zeros(size(r{2}, 1), 1))};
r_outer(1) = {zeros(size(r{1}, 1), 1)};
r_outer(2) = {zeros(size(r{2}, 1), 1)};
pow(1) = {zeros(size(r{1}, 1), 1)};
pow(2) = {zeros(size(r{2}, 1), 1)};
for i = 1 : 2
    for j = 1 : size(p{i}, 1)
        for k = 1 : 50
            if isequal(p{i}(j, 1), P_x0(k)) && isequal(p{i}(j, 2), P_y0(k))
                pow{i}(j) = dem(k);
                break;
            end
        end
    end
end
save('t3_input', 'G', 'p', 'r', 'ncp', 'fa_', 'is_optimized', 'r_outer', 'pow');