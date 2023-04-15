```bash
+---code
|   +---MATLAB	// 初赛使用MatLab
|   |   \---before
|   \---t34	// 决赛34问代码
+---data	// 有我们自己生成的数据文件，也有决赛的数据
\---doc		// 文档也是分了初赛决赛
    \---初赛
```



#### 主要模型和算法

1. 基于最小生成树的配电网拓扑设计：由于各线路之间造价比相近，因此初步可以近似为同等造价，使用最小生成树对网络的拓扑结构进行大致的确定。

<img src="C:\Users\DELL\AppData\Roaming\Typora\typora-user-images\image-20230415201120221.png" alt="image-20230415201120221" style="zoom:50%;" />

2. 基于几何分析的二分类算法

<img src="C:\Users\DELL\AppData\Roaming\Typora\typora-user-images\image-20230415201250104.png" alt="image-20230415201250104" style="zoom:50%;" />

3. 用电可靠性精确概率模型

![image-20230415201516805](C:\Users\DELL\AppData\Roaming\Typora\typora-user-images\image-20230415201516805.png)

<img src="C:\Users\DELL\AppData\Roaming\Typora\typora-user-images\image-20230415201423795.png" alt="image-20230415201423795" style="zoom: 33%;" />

4. 双供电网模型

<img src="C:\Users\DELL\AppData\Roaming\Typora\typora-user-images\image-20230415201648112.png" alt="image-20230415201648112" style="zoom:50%;" />

<img src="C:\Users\DELL\AppData\Roaming\Typora\typora-user-images\image-20230415201632716.png" alt="image-20230415201632716" style="zoom: 67%;" />

5. 基于启发式准则的贪心算法

<img src="C:\Users\DELL\AppData\Roaming\Typora\typora-user-images\image-20230415201944321.png" alt="image-20230415201944321" style="zoom:50%;" />

6. 负荷分块改进算法：对于任意负荷点，它和主线上分叉点的用电可靠性之比为一个固定常数，不会因增设联络线而改变。

<img src="C:\Users\DELL\AppData\Roaming\Typora\typora-user-images\image-20230415202116684.png" alt="image-20230415202116684" style="zoom:50%;" />

#### 比赛回顾

初赛是在数学建模国赛之前的一段时间，想赛前练兵就参加了。一开始觉得这个比赛门槛很高（记得比赛通知上写着面向高校，研究院），其实不然，虽然比赛题目很难，但是参加的基本还是我们这些大二、大三备战国赛的学生，评价标准也和国赛一样，甚至评委都是国赛那帮老师。

唯一不同是时间长了，可以花更多时间打磨自己的模型方法（虽然我们队还是前面没怎么做最后肝了一个星期），而且回报很不错，每道题目是6个奖，几等奖几个队，我们是第五名，三等奖，拿了3k的奖金（二等8k，一等3w！），还有线下的颁奖典礼可以公费旅游一波。

决赛会发布修改意见，安排了线上答辩，我们选的是B题——基于用电可靠性的配电网规划，还有数据需要验证，而且这个数据是在答辩前两天才发布，答辩重点就是围绕着修改意见。决赛我们的模型几乎推倒重建（要有心理准备，因为真的跟组委会想不到一块去），后来发现要用到深度优先搜索以及一些数据结构，最后边看世界杯边用C++写了一通宵。