function PPIT(grid_length)
% In APIT, the sensor nodes are not homogeneous
% the communication range of anchors is larger than that of unknown nodes
% comm_r: the communication range of the unknown node. it's saved in neighbor.mat
% the communication range of the anchor node is : times * comm_r, saved in neighbor.mat
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    load '../Deploy Nodes/coordinates.mat';
    load '../Topology Of WSN/neighbor.mat';
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    disp('时间较长，耐心等待...');
    unknown_node_index=all_nodes.anchors_n+1:all_nodes.nodes_n;
    row_n=ceil(all_nodes.square_L/grid_length);    col_n=row_n;
    centroid_x=repmat(([1:col_n]-0.5)*grid_length,row_n,1);
    centroid_y=repmat(transpose(([1:row_n]-0.5)*grid_length),1,col_n);
    for i=unknown_node_index   
        disp([num2str(i),':我在跑，不要催啦...']);
        neighboring_anchor_index=find(neighbor_matrix(i,1:all_nodes.anchors_n)==1);
        neighboring_anchor_n=length(neighboring_anchor_index);
        if neighboring_anchor_n>=3
            gridmap=zeros(row_n,col_n);
            grid_covered_flag=zeros(row_n,col_n);
            for a=1:neighboring_anchor_n-2
                for b=a+1:neighboring_anchor_n-1
                    for c=b+1:neighboring_anchor_n
                        %~~判断未知节点i是否在三角形abc内部
                        % Approximate P.I.T Test: "If no neighbor of M is further from/close to all three anchors A, B and C simultaneously,
                        % M assumes that it is inside triangle abc. Otherwise,M assumes it resides outside the triangle."
                        in_judge=inpolygon(all_nodes.true(i,1),all_nodes.true(i,2),all_nodes.estimated(neighboring_anchor_index([a b c]),1),all_nodes.estimated(neighboring_anchor_index([a b c]),2));                
                        if ~in_judge
                            Grid_in_triangle_abc=inpolygon(centroid_x,centroid_y,all_nodes.estimated(neighboring_anchor_index([a b c]),1),all_nodes.estimated(neighboring_anchor_index([a b c]),2));%被三角形abc覆盖到的网格
                            gridmap=gridmap-Grid_in_triangle_abc;                              
                        else%inside
                            Grid_in_triangle_abc=inpolygon(centroid_x,centroid_y,all_nodes.estimated(neighboring_anchor_index([a b c]),1),all_nodes.estimated(neighboring_anchor_index([a b c]),2));%被三角形abc覆盖到的网格
                            gridmap=gridmap+Grid_in_triangle_abc;                            
                        end
                        grid_covered_flag=grid_covered_flag|Grid_in_triangle_abc;
                    end
                end
            end           
            if any(any(grid_covered_flag))
                weight_max=max(max(gridmap(grid_covered_flag)));            
                weight_max_index=intersect(find(gridmap==weight_max),find(grid_covered_flag==1));
                [weight_max_ind_row,weight_max_ind_col]=ind2sub(size(gridmap),weight_max_index);
                all_nodes.estimated(i,:)=mean([weight_max_ind_col weight_max_ind_row;weight_max_ind_col weight_max_ind_row]*grid_length-0.5*grid_length);
                all_nodes.anc_flag(i)=2;
            end
        end
    end
    save '../Localization Error/result.mat' all_nodes comm_r;
end