%any problem, contact at zhenzhongdong@gmail.com(valid before 7.1.2010)
%Zenzon Don 2010.5.3
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
clear;
clc;
close all;
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%~~~~~~~~~~~~~~~~~~~~~~~布置节点，画节点分布图~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cd 'Deploy Nodes'
square_random(1000,300,0.2);%布置节点 GPS误差为0 
%square_random(1000,300,0.2,30) %GPS误差为30m
%C_random([1000,300,300,700],240,0.2);
%square_regular(1000,100,0.1,0.2);
%C_regular([1000,300,300,700],100,0.1,0.2);
Distribution_Of_WSN;%画节点分布图
cd ..;
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% ~~~~~~~~~~~~ 给定通信半径，选择通信模型，计算邻居关系，画邻居关系图~~~~~~~~~~
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cd 'Topology Of WSN';
comm_r=200;%给定通信半径
%~~~~~~~~~~~~~~~~~~选择通信模型~~~~~~~~~~~~~~~~~ 
model='Regular Model';
%model='Logarithmic Attenuation Model';
%disp('时间可能较长...');model='DOI Model';DOI=0.015;
%disp('时间可能较长...');model='RIM Model';DOI=0.01;
%~~~~~~~~~~~~~~~~~~计算邻居关系~~~~~~~~~~~~~~~~~
anchor_comm_r=1;
%anchor_comm_r参数只在APIT中更改，其他的算法统一设置为1。
%它表示锚节点通信半径是未知节点通信半斤的倍数。
%APIT针对的WSN是异构的，锚节点通信半径比未知节点的大。
try
    calculate_neighbor(comm_r,anchor_comm_r,model,DOI);
catch
    calculate_neighbor(comm_r,anchor_comm_r,model);
end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Topology_Of_WSN;%画邻居关系图
cd ..;
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~选择定位算法~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%cd Centroid;Centroid(20,0.9);%Centroid_second(20,0.9);%Centroid_third(...
%cd 'Bounding Box';Bounding_Box;%Bounding_Box_second;%Bounding_Box_third;
%cd 'Grid Scan';Grid_Scan(0.1*comm_r);%Grid_scan_second(...
%cd RSSI;RSSI;%RSSI_second;%RSSI_third;
%~~~~~~~~~~~~~~~~~~~~~~~~
%cd 'DV-hop';DV_hop;
%cd Amorphous;Amorphous;
%cd APIT;APIT(0.1*comm_r);
dist_available=true;cd 'MDS-MAP';MDS_MAP(dist_available);
cd ..
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%~~~~~~~~~~~~~~~~~~~~~~~~~~~计算定位误差，画定位误差图~~~~~~~~~~~~~~~~~~~~~~~
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cd 'Localization Error'
calculate_localization_error;
cd ..;
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~