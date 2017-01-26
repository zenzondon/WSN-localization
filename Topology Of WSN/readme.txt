Zenzon Don  (any problem, contact at zhenzhongdong@gmail.com    valid before 7.1.2010)
4.25.2010
------------------------------------------------------------------------------------------------------------

文件名：
文件夹:
Transmission Model
功能:
定义了4个通信模型: Regular Model, DOI Model, Logarithmic Attenuation Model, RIM Model


-------------------------------------------------------------------------------------------------------------

calculate_neighbor.m
功能：
给定通信半径，选定传播模型，计算'../Deploy Nodes/coordinates.mat'的节点邻居关系
邻居关系数组neighbor_matrix，邻居间的信号强度数组neighbor_rss保存在数据文件neighbor.mat中
调用格式：
calculate_neighbor(comm_r,times,model,DOI)
comm_r:未知节点的通信半径
times:锚节点通信半径是未知节点通信半径的倍数。APIT是异构WSN，锚节点通信半径比未知节点通信半径大。对于其他的算法，times设为1。
model:'Regular Model','Logarithmic Attenuation Model','DOI Model','RIM Model',缺省为'Regular Model'
model为'DOI Model','RIM Model'时,需要DOI参数

-------------------------------------------------------------------------------------------------------------

文件名：
neighbor.mat
功能：
保存节点的邻居关系数组neighbor_matrix和邻居间的信号强度数组neighbor_rss
关于neighbor_matrix：
	
	1	2	3	4	5	…发送方
       _______________________________________________________
  1       |	0	0	1	0	1
           |
  2       |	0	0       	0	1	0
           |
  3       |	1	0	0	1	0
           |
  4       |	0	1	1	0	1
           |
  5       |	1	0	0	1	0
  .        |
  .        |
 接      |
 收      |
 方      |
neighbor_matrix(i,j)==1，表示"节点i "能接收到"节点j "的信号;
neighbor_matrix不一定对称,即"节点i"能接收到"j"的信号,不代表"节点j"也能接收到"i"的信号;

"节点i"利用其邻居节点进行定位,它的邻居节点是neighbor_matrix(i,:)还是neighbor_matrix(:,i)呢??
应该是neighbor_matrix(i,:),即是"节点i"能接收到信号的那些节点.
因为:考虑APIT中的异构WSN,锚节点的通信半径比未知节点通信半径大很多,节点的邻居应该是它能接受到信号的那些点,这样未知节点就可以利用相隔很远的锚节点的信息了.
-------------------------------------------------------------------------------------------------------------

文件名：
Topology_Of_WSN.m
功能：
根据'../Deploy Nodes/coordinates.mat'和neighbor.mat画出节点的邻居关系图
请确保neighbor.mat与'../Deploy Nodes/coordinates.mat'对应，即neighbor.mat是从当前的'../Deploy Nodes/coordinates.mat'运行calculate_neighbor.m得到的
调用格式：
Topology_Of_WSN


-------------------------------------------------------------------------------------------------------------
文件夹：
Figures
节点邻居关系图保存于此
