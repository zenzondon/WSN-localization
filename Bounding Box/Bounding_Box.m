function Bounding_Box()
% 未知节点利用邻居锚节点进行定位，没有邻居锚节点的未知节点无法定位。
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    load '../Deploy Nodes/coordinates.mat';
    load '../Topology Of WSN/neighbor.mat';
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    unknown_node_index=all_nodes.anchors_n+1:all_nodes.nodes_n;
    for i=unknown_node_index
        neighboring_anchor_index=intersect(find(neighbor_matrix(i,:)==1),find(all_nodes.anc_flag==1));%只利用邻居锚节点进行定位
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
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    save '../Localization Error/result.mat' all_nodes comm_r;
end
                
