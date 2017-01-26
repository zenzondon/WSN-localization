% Zenzon Don  5.15.2010
% 画MDS得到的中间结果图--relative map
% 画relative map经过MAP后得到的最终结果图--absolute map
% 节点的真实分布图运行'../Deploy Nodes/Distribution_Of_WSN.m'
% 定位的结果图运行'../Localization Error/calculate_localization_error.m'
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

load maps_and_all_nodes.mat;
figure;%画relative map
hold on; 
plot(relative_map(1:all_nodes.anchors_n,1),relative_map(1:all_nodes.anchors_n,2),'r*');
plot(relative_map(all_nodes.anchors_n+1:all_nodes.nodes_n,1),relative_map(all_nodes.anchors_n+1:all_nodes.nodes_n,2),'bo');
title('relative map');

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

figure;%画absolute map
hold on; 
plot(absolute_map(1:all_nodes.anchors_n,1),absolute_map(1:all_nodes.anchors_n,2),'r*');
plot(transpose([absolute_map(1:all_nodes.anchors_n,1),all_nodes.estimated(1:all_nodes.anchors_n,1)]),...
    transpose([absolute_map(1:all_nodes.anchors_n,2),all_nodes.estimated(1:all_nodes.anchors_n,2)]),'r-');
plot(absolute_map(all_nodes.anchors_n+1:all_nodes.nodes_n,1),absolute_map(all_nodes.anchors_n+1:all_nodes.nodes_n,2),'bo');
title('absolute map');
disp('absolute map中红线表示锚节点在absolute map中的坐标与其真实坐标的偏差');