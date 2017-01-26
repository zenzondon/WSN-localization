function Centroid_second(packet_sent_n,CM_threshold)
% packet_sent_n:节点发送的包数目
% CM_threshold:连通度阈值
% Centroid算法详见该文件夹下的pdf文件
% 如果接受节点接收到的包数目与发送节点发送的包数目的比值大于CM_threshold,则这两个节点视为邻居节点
% 未知节点一旦被定位就充当起锚节点的功能，向周围邻居发送自己的估计坐标信息
% 未知节点把已经定位的未知节点与锚节点同等对待
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    directory=cd;
    cd '../Topology Of WSN';
    connectivity_metric=0;
    for i=1:packet_sent_n
        load neighbor.mat;
        connectivity_metric=connectivity_metric+neighbor_matrix;
        try
            calculate_neighbor(comm_r,anchor_comm_r,model,DOI);
        catch
            calculate_neighbor(comm_r,anchor_comm_r,model);
        end
    end
    cd(directory);
    CM=connectivity_metric>=packet_sent_n*CM_threshold;
    load '../Deploy Nodes/coordinates.mat';
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    unknown_node_index=all_nodes.anchors_n+1:all_nodes.nodes_n;
    while true
        for i=unknown_node_index         
            neighboring_anchor_index=intersect(find(CM(i,:)==1),find(all_nodes.anc_flag~=0));%已经定位的未知节点也视为锚节点
            if ~isempty(neighboring_anchor_index)
                all_nodes.estimated(i,:)=mean([all_nodes.estimated(neighboring_anchor_index,:);all_nodes.estimated(neighboring_anchor_index,:)]);
                all_nodes.anc_flag(i)=2;
            end
        end
        try
           unknown_node_index==transpose(find(all_nodes.anc_flag==0));
           break;
        catch
            unknown_node_index=transpose(find(all_nodes.anc_flag==0));
        end
    end
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    save '../Localization Error/result.mat' all_nodes comm_r;
end