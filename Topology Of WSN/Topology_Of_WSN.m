load '../Deploy Nodes/coordinates.mat';
load neighbor.mat;
figure;
hold on;
box on;
for i=1:all_nodes.nodes_n
    for j=i+1:all_nodes.nodes_n
        if neighbor_matrix(i,j)==1
            plot(all_nodes.true([i,j],1),all_nodes.true([i,j],2),'-b');
        end
    end
end
plot(all_nodes.true(all_nodes.anchors_n+1:all_nodes.nodes_n,1),all_nodes.true(all_nodes.anchors_n+1:all_nodes.nodes_n,2),'ro');
plot(all_nodes.true(1:all_nodes.anchors_n,1),all_nodes.true(1:all_nodes.anchors_n,2),'r*');
axis([0,all_nodes.square_L,0,all_nodes.square_L]);
title('邻居关系图');
disp('~~~~~~~~~~~~~~~~~~~~~~~~邻居关系图~~~~~~~~~~~~~~~~~~~~~~~~~~');
disp([num2str(all_nodes.nodes_n),'个节点,','其中',num2str(all_nodes.anchors_n),'个锚节点']);
disp('红色*表示锚节点，红色O表示未知节点');
disp(['通信半径:',num2str(comm_r),'m']);
disp(['锚节点的通信半径:',num2str(comm_r*anchor_comm_r),'m']);
disp(['通信模型:',model]);
try
    disp(['DOI=',num2str(DOI)]);
catch
    %none
end
if anchor_comm_r==1
    disp(['网络的平均连通度为:',num2str(sum(sum(neighbor_matrix))/all_nodes.nodes_n)]);
    disp(['网络的邻居锚节点平均数目为:',num2str(sum(sum(neighbor_matrix(1:all_nodes.nodes_n,1:all_nodes.anchors_n)))/all_nodes.nodes_n)]);
else
    disp(['未知节点能侦听到的锚节点平均数目为:',num2str(sum(sum(neighbor_matrix(all_nodes.anchors_n+1:all_nodes.nodes_n,1:all_nodes.anchors_n)))/(all_nodes.nodes_n-all_nodes.anchors_n))]);
    disp(['未知节点通信区域内的未知节点平均数目为:',num2str(sum(sum(neighbor_matrix(all_nodes.anchors_n+1:all_nodes.nodes_n,all_nodes.anchors_n+1:all_nodes.nodes_n)))/(all_nodes.nodes_n-all_nodes.anchors_n))]); 
end

