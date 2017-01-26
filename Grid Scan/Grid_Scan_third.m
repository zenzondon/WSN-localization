function Grid_Scan_third(grid_length)
% 有邻居锚节点的未知节点只利用邻居锚节点进行定位，没有邻居锚节点的未知节点才利用已经定位了的邻居未知节点进行定位。
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    load '../Deploy Nodes/coordinates.mat';
    load '../Topology Of WSN/neighbor.mat';    
    row_n=ceil(all_nodes.square_L/grid_length);
    col_n=row_n;
    centroid_x=repmat(([1:col_n]-0.5)*grid_length,row_n,1);
    centroid_y=repmat(transpose(([1:row_n]-0.5)*grid_length),1,col_n);
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    loop=1;% 有邻居锚节点的未知节点只利用邻居锚节点进行定位
    unknown_node_index=all_nodes.anchors_n+1:all_nodes.nodes_n;
    while true
        for i=unknown_node_index
            neighboring_anchor_index=intersect(find(neighbor_matrix(i,:)==1),find(all_nodes.anc_flag==1|all_nodes.anc_flag==loop));
            if ~isempty(neighboring_anchor_index)
                gridmap=zeros(row_n,col_n);
                for j=neighboring_anchor_index
                    x=repmat(all_nodes.estimated(j,1),row_n,col_n);
                    y=repmat(all_nodes.estimated(j,2),row_n,col_n);
                    dist=sqrt((centroid_x-x).^2+(centroid_y-y).^2);
                    gridmap=gridmap+(dist<comm_r);
                end
                weight_max=max(max(gridmap));
                weight_max_index=find(gridmap==weight_max);
                [weight_max_ind_row,weight_max_ind_col]=ind2sub(size(gridmap),weight_max_index);
                max_value_n=length(weight_max_ind_row);
                all_nodes.estimated(i,:)=mean([weight_max_ind_col weight_max_ind_row;weight_max_ind_col weight_max_ind_row]*grid_length-0.5*grid_length);
                all_nodes.anc_flag(i)=2;
            else
                continue;
            end     
        end
        try
           unknown_node_index==transpose(find(all_nodes.anc_flag==0));
           break;
        catch
            unknown_node_index=transpose(find(all_nodes.anc_flag==0));
        end
        loop=2;%没有邻居锚节点的未知节点才利用已经定位了的邻居未知节点进行定位
    end
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    save '../Localization Error/result.mat' all_nodes comm_r;
end
                