
在尝试传统方法后，我们针对问题优化目标提出一种启发式二分类算法：
[1] 作两个电源之间连线 $l=K_1K_2$，设 $l$ 的中点为 $M(x_M,y_M)$，令 $$k=\frac{y_{K1}-y_{K2}}{x_{K1}-x_{K2}}$$
用直线方程一般式描述 $l$ 得
$$ l:f(x,y)=y-y_M-k(x-x_M)=0 $$

[2] 作 $l_1,l_2$ 垂直于 $l$，且关于点 $M$ 对称，设 $l_1,l_2$ 和 $l$ 的交点分别为 $T_1,T_2$，令 $t=T_1M=T_2M$，根据几何关系得
$$
\begin{cases}
x_{T1,2}=x_M\pm\frac{kt}{\sqrt{k^2+1}} \\
y_{T1,2}=y_M\pm\frac{t}{\sqrt{k^2+1}}
\end{cases}
$$
同样通过一般式描述 $l_1,l_2$：
$$
\begin{cases}
l1:f_1(x,y)=y-y_{T1}+\frac{1}{k}(x-x_{T1})=0 \\
l2:f_2(x,y)=y-y_{T2}+\frac{1}{k}(x-x_{T2})=0
\end{cases}
$$

$l_1,l_2$ 将平面点集划分成 $P_1,P_3,P_2$的3个部分，其中
$$
\begin{cases}
P_1=\{(x_i,y_i)|f_1(x_i,y_i)<0\} \\
\ \\
P_2=\{(x_i,y_i)|f_2(x_i,y_i)>0\} \\
\ \\
P_3=\{(x_i,y_i)|f_1(x_i,y_i)*f_2(x_i,y_i)<0\}
\end{cases}
$$


[3] 选择一个较小的值 $\alpha$，平移 $l_1,l_2$，即改变 $t$ 使得 $|P_3|=\alpha$，这里可通过二分法确定 $t$ 值；
[4] 将 $P_1$ 和 $K_1$ 分类至集合 $S_1$，$P_2$ 和 $K_2$ 分类至集合 $S_2$，
用一个01状态向量 $s$ 描述 $P_3$ 中点的分类情况，其中 '0' 代表点属于 $S1$，'1' 代表点属于 $S_2$，设 $P_3$ 中属于 $S_1$ 的点集为 $s_1$ ,属于 $S_2$ 的为 $s_2$，据此简洁地描述分类情况：
$$ S_i=P_i\cup{s_i},i=1,2 $$

[5]枚举状态向量 $s$；

[6] 对集合 $S_1,S_2$ 各自建立问题一中的单供配电网模型，各自求得 $min_{S1}(cost_{sum})$ 以及 $min_{S2}(cost_{sum})$，设 $cost=min_{S1}(cost_{sum})+min_{S2}(cost_{sum})$，$cost_{best}$ 为最优的 $cost$，$S_{best}$ 为最优 $cost$ 对应的 $S_1$

[7] 更新 $cost_{best}$ 以及 $S_{best}$；
[8] 若枚举还未结束，回到 [5]，否则结束。


$$ min(min_{S1}(cost_{sum})+min_{S2}(cost_{sum})) $$
$$
\begin{cases}
k=\frac{y_{K1}-y_{K2}}{x_{K1}-x_{K2}} \\
\\
\begin{cases}
l:f(x,y)=y-y_M-k(x-x_M)=0 \\
l1:f_1(x,y)=y-y_{T1}+\frac{1}{k}(x-x_{T1})=0 \\
l2:f_2(x,y)=y-y_{T2}+\frac{1}{k}(x-x_{T2})=0
\end{cases} \\
\ \\
\begin{cases}
P_1=\{(x_i,y_i)|f_1(x_i,y_i)<0\} \\
\ \\
P_2=\{(x_i,y_i)|f_2(x_i,y_i)>0\} \\
\ \\
P_3=\{(x_i,y_i)|f_1(x_i,y_i)*f_2(x_i,y_i)<0\}
\end{cases} \\
\ \\
S_i=P_i\cup{s_i},i=1,2 \\
\ \\
load[i]=
\begin{cases}
1,& \text{ $i\in{L}$ } \\
\sum_{s_{ij}\in{son_i}}{load[s_{ij}]},& \text{ $i\in{B}$ }
\end{cases} \\
\\
type(ifa_i)=
\begin{cases}
1(主线),& \text{ $fa_i=bat$ } \\
2(支线A),& \text{ $load[i]\leq2$ } \\
3(支线B),& \text{ $load[i]>2$ }
\end{cases} \\
\\
dis(i,j)=\sqrt{(x_i-x_j)^2+(y_i-y_j)^2} \\
\\
length(k)=\sum_{G(i,j)=1\ 且\ type(i,j)=k}{dis(i,j)},k=1,2,3 \\
\\
r[i]=r[fa_i]*(1-0.5\%)*(1-0.2\%)*(1-0.002*dis(i,fa_i))
\end{cases}
$$
