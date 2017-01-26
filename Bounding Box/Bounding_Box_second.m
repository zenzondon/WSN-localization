function Bounding_Box_second()
% 未知节点一旦被定位就充当起锚节点的功能，向周围邻居发送自己的估计坐标信息
% 未知节点把已经定位的未知节点与锚节点同等对待
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    load '../Deploy Nodes/coordinates.mat';
    load '../Topology Of WSN/neighbor.mat';
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    unknown_node_index=all_nodes.anchors_n+1:all_nodes.nodes_n;
    while true
        for i=unknown_node_index
            neighboring_anchor_index=intersect(find(neighbor_matrix(i,:)==1),find(all_nodes.anc_flag~=0));%已经定位的未知节点也视为锚节点
            if ~isempty(neighboring_anchor_index)
                left=[];right=[];upper=[];down=[];
                left=max(all_nodes.estimated(neighboring_anchor_index,1)-comm_r);
                right=min(all_nodes.estimated(neighboring_anchor_index,1)+comm_r);
                upper=min(all_nodes.estimated(neighboring_anchor_index,2)+comm_r);
                down=max(all_nodes.estimated(neighboring_anchor_index,2)-comm_r);
                if left>=right || down>=upper
                    continue;
                end
                %下面的代码用于：正方形监测区域的边界已知，Bounding Box不应该超出监测区域的边界。
                %left=max(left,0);
                %right=min(right,all_nodes.square_L);
                %down=max(down,0);
                %upper=min(upper,all_nodes.square_L);
                %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                all_nodes.estimated(i,:)=mean([left down;right upper]);
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
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    save '../Localization Error/result.mat' all_nodes comm_r;
end
                
