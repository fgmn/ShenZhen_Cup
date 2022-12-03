#include <bits/stdc++.h>
#define MAXPATH 10
using namespace std;
const int N = 55;
// 线路以及开关单位造价
const double cost_circuit1 = 325.7;
const double cost_link = 2 * cost_circuit1;
const double cost_switch2 = 56.8;
// 故障单元可靠性
const double r_node = (1 - 0.005);
const double r_switch = (1 - 0.002);
const double errate_line = 0.002;

int lamb[2];

struct load {
	double x, y;
	double r, r0;
	double c;	// r(loadj)/r(Ki)=c
	int lev;	// 优化级数
	int K;		// 所属分叉点
	bool operator < (const load &a) const {
		return r > a.r;	// 最低用电可靠性优先
	}
};

struct node {
	int num;		// 节点编号
	double x, y;	// 节点坐标
	int nu;			// 节点支线连接子树中负荷总数

	// more
	double r[N / 2];	// 考虑不同数量供电路径的可靠性
	int cnt_path;		// 可供电路径数量
	vector<load> Load;	// 支线连接子树中的负荷
	priority_queue<load> pq;	// 第一级最小堆
} Node[N];
/*
节点编号：1号网络为1-n，2号网络为(n+1)-(n+m)
电源编号为1和(n+1)
*/

priority_queue<load> gpq;	// 第二级最小堆，也称全局最小堆

struct line {
	int u, v;		// 线关联两端点
	int Nuv[2];		// Nuv[0]=nu+nv,Nuv[1]=|nu-nv|
	double len;		// 线路长度
	double cost;	// 建造花费
	double fval;	// 启发式函数值

	bool operator < (const line& a) const {
		return fval > a.fval;	// min f()
	}
};

struct circ {
	int u, v;
	double r;
	bool operator < (const circ& a) const {
		return u < a.u;
	}
};

struct path {	// 供电路径
	set<circ> subpath;	// 子路径集合
} Path[MAXPATH];
int cnt;

vector<node> Net[2];	// 两个单供网络主线上的分叉点集合
int n, m;

vector<int> dnet[N];	// 双供网络邻接表
map<pair<int, int>, bool> cont;

void read_graph();
void read_rdata();

// 启发式贪心算法
void heuristic_greedy_method(vector<node> net[2]);
// 负荷分块改进算法
void load_partition_improved_method(vector<node> net[2], int k);
// 基于n元容斥定理计算主线上分叉点的用电可靠性
void calc_reliability();
// 两级最小堆方案优化最低用电可靠性
void Two_Level_Heap_optimization();

double dis(node &a, node &b);		// 两点之间距离函数
bool judge_cross(line &a, line &b);	// 判断线是否相交
vector<node> load_partition(vector<node> net, int k);	// 负荷分块
void dfs(int u, int fa, int flag);	// dfs所有供电路径

int main() {
	freopen("data.txt", "r", stdin);

	// 协调变量设定
	lamb[0] = lamb[1] = 0;

	// 数据输入
	read_graph();
	// 应用贪心算法
	heuristic_greedy_method(Net);
	// 应用负荷分块改进后的算法
	load_partition_improved_method(Net, 2);

	//for (int i = 0; i < n + m; i++) {
	//	cout << "(" << i << ")";
	//	for (int j : dnet[i]) {
	//		cout << j << " ";
	//	}	cout << '\n';
	//}

	// 计算主线分叉点可靠性
	calc_reliability();
	read_rdata();
	// 两级堆方案优化
	Two_Level_Heap_optimization();

	for (int i = 2; i <= n + m; i++) {
		if (i == (n + 1)) continue;
		for (int j = 0; j < Node[i].Load.size(); j++) {
			//cout << Node[i].Load[j].x << '\n';
			cout << Node[i].Load[j].y << '\n';
			//cout << Node[i].Load[j].r << '\n';
		}
	}
	return 0;
}

void read_graph() {
	cin >> n >> m;
	//cout << n << ' ' << m << '\n';
	double x, y;
	for (int i = 1; i <= n; i++) {
		cin >> x >> y;
		Node[i].num = i;
		Node[i].x = x; Node[i].y = y;
	}
	for (int i = 1; i <= m; i++) {
		cin >> x >> y;
		Node[n + i].num = n + i;
		Node[n + i].x = x; Node[n + i].y = y;
	}
	int k;
	vector<int> tmp;
	for (int i = 1; i <= n; i++) {
		cin >> k;
		tmp.push_back(k);
		if (k != 1) { Net[0].push_back(Node[k]); }
	}
	for (int i = 0; i < n - 1; i++) {
		dnet[tmp[i + 1]].push_back(tmp[i]);
	}	// 构建双供网络邻接表
	tmp.clear();
	for (int i = 1; i <= m; i++) {
		cin >> k;
		tmp.push_back(n + k);
		if (k != 1) { Net[1].push_back(Node[n + k]); }
	}
	for (int i = 0; i < m - 1; i++) {
		dnet[tmp[i + 1]].push_back(tmp[i]);
	}
}

void read_rdata() {
	string line;
	double r;
	getchar();	// '\n'
	cout << '\n';
	for (int i = 2; i <= n + m; i++) {
		if (i == (n + 1)) continue;
		getline(cin, line);
		stringstream sstream(line);
		while (sstream >> r) {
			//cout << r << ' ';
			load newone;
			newone.r = r;
			newone.r0 = r;
			newone.c = newone.r0 / Node[i].r[1];
			newone.K = i;
			newone.lev = 1;
			Node[i].Load.push_back(newone);
			Node[i].pq.push(newone);
		}	//cout << '\n';
	}
	double x, y;
	for (int i = 2; i <= n + m; i++) {
		if (i == (n + 1)) continue;
		for (int j = 0; j < Node[i].Load.size(); j++) {
			cin >> x >> y;
			Node[i].Load[j].x = x;
			Node[i].Load[j].y = y;
		}
	}
}

void heuristic_greedy_method(vector<node> net[2]) {
	vector<line> L_cont;	// 联络线设置集合
	double cost_cont = 0;	// 当前联络线花费
	priority_queue<line> pq;

	for (node &i : net[0]) {
		for (node &j : net[1]) {
			line new_one;
			new_one.u = i.num; new_one.v = j.num;
			new_one.len = dis(i, j) / 1000;		// (km)
			new_one.cost = new_one.len * cost_link + 2 * cost_switch2;
			new_one.Nuv[0] = i.nu + j.nu;
			new_one.Nuv[1] = abs(i.nu - j.nu);
			new_one.fval = new_one.len - lamb[0] * new_one.Nuv[0] + lamb[1] * new_one.Nuv[1];
			//printf("(%d,%d):{length:%lf,cost:%lf,Nuv:(%d,%d),fval:%lf}\n", \
			//	new_one.u, new_one.v, new_one.len, new_one.cost, new_one.Nuv[0], new_one.Nuv[1], new_one.fval);
			pq.push(new_one);
		}
	}

	while (!pq.empty()) {
		line new_cont = pq.top();
		pq.pop();
		bool flag = true;
		for (line &i : L_cont) {
			if (!judge_cross(i, new_cont)) {
				flag = false;	// 不满足约束<2>
				break;
			}
		}
		if (flag) {
			L_cont.push_back(new_cont);	// {L_cont} ∪ {new_cont}
			cost_cont += new_cont.cost;
			//printf("{%lf,%lf}\n", cost_cont, new_cont.cost);
		}
		//else { break; }
	}
	//return L_cont;

	cout << "{L_cont}={";
	int L = L_cont.size();
	for (int i = 0; i < L; i++) {
		cout << "(" << L_cont[i].u << "," << L_cont[i].v << ")" << ",}"[i == L - 1];
		dnet[L_cont[i].u].push_back(L_cont[i].v);
		dnet[L_cont[i].v].push_back(L_cont[i].u);
		cont[{L_cont[i].u, L_cont[i].v}] = true;
		cont[{L_cont[i].v, L_cont[i].u}] = true;
	}
	cout << '\n';
}

void load_partition_improved_method(vector<node> net[2], int k) {
	// k为分块大小
	vector<node> vir_net[2];
	vir_net[0] = load_partition(net[0], k);
	vir_net[1] = load_partition(net[1], k);
	int n = vir_net[0].size(), m = vir_net[1].size();
	if (n < m) {
		swap(vir_net[0], vir_net[1]);
		swap(n, m);
	}	// n >= m
	// 将主线末端虚拟点进一步合并，保证最终n=m
	for (int i = 0; i < n - m; i++) {
		vir_net[0][m - 1].x += vir_net[0][n - i - 1].x;
		vir_net[0][m - 1].y += vir_net[0][n - i - 1].y;
	}
	vir_net[0][m - 1].x /= (n - m + 1);
	vir_net[0][m - 1].y /= (n - m + 1);	// 将（n1-n2+1）个点合并

	/*
	todo:|{L_cont}*|=max(|{L_cont}|)
	but O(n!)
	*/
}

void calc_reliability() {
	for (int i = 2; i <= n + m; i++) {
		if (i == n + 1) continue;
		cnt = 0;
		dfs(i, 0, 0);	// Path[0-(cnt-1)]

		//cout << "[" << i << "]" << '\n';
		//for (int j = 0; j < cnt; j++) {
		//	for (circ k : Path[j].subpath) {
		//		cout << "(" << k.u << "," << k.v << ")";
		//	}cout << '\n';
		//}
		//break;
		//cout << "r:";
		Node[i].cnt_path = cnt;
		for (int j = 1; j <= cnt; j++) {	// 考虑前j条供电路径
			// 邻接表的建立次序保证第一条为正常供电路径
			double r = 0;
			if (j == 1) {
				r = 1;
				for (circ k : Path[0].subpath) {
					r *= k.r;
				}
				r *= r_node;	// 考虑电源可靠性
			}
			else {
				// 容斥原理
				for (int k = 1; k < (1 << j); k++) {	// 0/1状态压缩，共j位代表j条路径
					set<circ> uset;	// 路径求并
					int op = -1;	// 奇数项为正
					for (int t = 0; t < j; t++) {
						if ((1 << t) & k) {
							set_union(Path[t].subpath.begin(), Path[t].subpath.end(), \
								uset.begin(), uset.end(), inserter(uset, uset.begin()));
							op = -op;
						}
					}
					double r_item = 1;
					for (circ cir : uset) {
						r_item *= cir.r;	// r(P1∩P2∩...∩Pn)
					}
					r_item *= r_node;
					r += op * r_item;
				}
			}
			Node[i].r[j] = r;
			//cout << r << ' ';
		}
		//cout << '\n';
	}
}

void Two_Level_Heap_optimization() {
	// 构建全局最小堆
	for (int i = 2; i <= n + m; i++) {
		if (i == (n + 1)) continue;
		load local_min = Node[i].pq.top();
		gpq.push(local_min);
	}
	
	for (int t = 1; t <= 1000; t++) {	// 第t轮优化
		// 单步优化
		load gm = gpq.top(); gpq.pop();
		Node[gm.K].pq.pop();
		gm.lev++;
		// 方案饱和，无法继续优化
		if (gm.lev > Node[gm.K].cnt_path) {
			cout << gm.r << '\n';
			cout << "Have reached saturation\n";
			break;
		}
		//cout << gm.r << '\n';
		//cout << gm.K << "  " << gm.r << "  ";
		gm.r = gm.c * Node[gm.K].r[gm.lev];
		//cout << gm.r << '\n';
		
		//printf("%lf×%lf\n", gm.c, Node[gm.K].r[gm.lev]);
		Node[gm.K].pq.push(gm);
		load lm = Node[gm.K].pq.top();
		gpq.push(lm);
	}
}

stack<circ> curr_path0;
set<circ> curr_path;

void dfs(int u, int fa, int flag) { // flag：保证只经过1条联络线
	// 若搜索到电源则发现一条供电路径
	if (u == 1 || u == n + 1) {
		Path[cnt++].subpath = curr_path;
		//return;
	}
	circ cir;
	for (int v : dnet[u]) {
		if (v != fa) {
			double d = dis(Node[u], Node[v]) / 1000;	// (km)
			//cout << "d:" << d << '\n';
			cir.u = u; cir.v = v;
			cir.r = (1 - d * errate_line) * r_switch;
			if (cont[{u, v}]) {
				if (flag) continue;
				flag++;
			}
			curr_path0.push(cir);
			curr_path.insert(cir);
			//cout << "push (" << u << "," << v << ")\n";
			dfs(v, u, flag);
			if (cont[{u, v}]) { flag--; }
		}
	}
	// 节点访问结束，弹栈
	if (!curr_path0.empty()) {
		cir = curr_path0.top(); curr_path0.pop();
		//cout << "pop (" << cir.u << "," << cir.v << ")\n";
		curr_path.erase(cir);
	}
}

vector<node> load_partition(vector<node> net, int k) {
	vector<node> vir_net; vir_net.clear();
	int n = net.size();
	for (int i = 0; i < n; i += k) {
		node new_node;
		double sumx, sumy;
		sumx = sumy = 0;
		int re = min(k, n - i);
		for (int j = 0; j < re; j++) {
			sumx += net[i].x;
			sumy += net[i].y;
		}
		new_node.x = sumx / re;
		new_node.y = sumy / re;
		vir_net.push_back(new_node);
	}
	return vir_net;
}

double dis(node& a, node& b) {
	return sqrt((a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y));
}

bool judge_cross(line& a, line& b) {
	node A, B, C, D;
	A = Node[a.u]; B = Node[b.u];
	C = Node[a.v]; D = Node[b.v];
	// 点A和D应在直线BC两侧
	// 需保证BC不和坐标轴平行
	double fa, fb;
	fa = (A.y - C.y) / (B.y - C.y) - (A.x - C.x) / (B.x - C.x);
	fb = (D.y - C.y) / (B.y - C.y) - (D.x - C.x) / (B.x - C.x);
	return (fa * fb < 0);
}