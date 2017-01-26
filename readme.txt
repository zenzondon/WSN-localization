
"未知节点可能因为没有邻居锚节点而无法定位"

实现算法可能的方法：
1. 未知节点利用邻居锚节点进行定位，没有邻居锚节点的未知节点无法定位。

2. 未知节点一旦被定位，就充当锚节点。这时没有邻居锚节点的未知节点在等到自己的邻居未知节点定位之后就可以进行定位。


3. 有邻居锚节点的未知节点只利用邻居锚节点进行定位，没有邻居锚节点的未知节点才利用已经定位了的邻居未知节点进行定位。


Centroid.m, Bounding_box.m, Grid_Scan.m,RSSI.m采用的第一种方法;
Centroid_second.m, Bounding_box_second.m, Grid_Scan_second.m,RSSI_second.m采用的第二种方法;
Centroid_third.m, Bounding_box_third.m, Grid_Scan_third.m,RSSI_third.m采用的第三种方法;

DV-hop，MDS-MAP不存在这三种方法的选择。

Centoid, Bounding_box, Grid_Scan, RSSI, DV_hop, MDS_MAP，APIT的执行在run.m中直接选择就可以了；



--Zenzon Don
--5.7.2010


