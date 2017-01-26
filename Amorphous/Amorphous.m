function Amorphous()
    load '../Deploy Nodes/coordinates.mat';
    load '../Topology Of WSN/neighbor.mat'; 
    if all_nodes.anchors_n<3
        disp('锚节点少于3个,DV-hop算法无法执行');
        return;
    end
    %~~~~~~~~~~~~~~~~~~~~~~~~~最短路经算法计算节点间跳数~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    shortest_path=neighbor_matrix;
    shortest_path=shortest_path+eye(all_nodes.nodes_n)*2;
    shortest_path(shortest_path==0)=inf;
    shortest_path(shortest_path==2)=0;
    for k=1:all_nodes.nodes_n
        for i=1:all_nodes.nodes_n
            for j=1:all_nodes.nodes_n
                if shortest_path(i,k)+shortest_path(k,j)<shortest_path(i,j)%min(h(i,j),h(i,k)+h(k,j))
                    shortest_path(i,j)=shortest_path(i,k)+shortest_path(k,j);
                end
            end
        end
    end
    if length(find(shortest_path==inf))~=0
        disp('网络不连通...需要划分连通子图...这里没有考虑这种情况');
        return;
    end
    %~~~~~~~~~~~~~~~~~~~~~~~~~每跳距离~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    % Amorphous是离线计算网络每跳距离的，它需要在网络部署之前就知道网络的平均连通度
    % 离线计算网络平均连通度：connectivity=(节点数/监测区域面积)*pi*R^2
    % 真实的网络平均连通度：(在网络部署完毕后通过节点通信收集整个网络的信息)
    % connectivity=sum(sum(neighobr_matrix))/all_nodes.nodes_n;
    try%C型网络
        area=all_nodes.area(1)^2-(all_nodes.area(4)-all_nodes.area(3))*(all_nodes.area(1)-all_nodes.area(2));
    catch
        area=all_nodes.square_L^2;
    end
    connectivity=all_nodes.nodes_n/area*pi*comm_r^2;
    syms t;
    temp=@(t)(exp(-connectivity/pi*(acos(t)-t.*sqrt(1-t.^2)))); 
    hopsize=comm_r*(1+exp(-connectivity)-sum(temp(-1:0.001:1)*0.001));%求校正值的积分matlab求不出来，只好求和逼近了
    %~~~~~~~~~~~~~~~~~~~~~~~每个未知节点开始计算自己的位置~~~~~~~~~~~~~~~~~~~~
    for i=all_nodes.anchors_n+1:all_nodes.nodes_n  
        neighboring_node_index=find(neighbor_matrix(i,:)==1);
        hop=mean(shortest_path([neighboring_node_index,i],1:all_nodes.anchors_n))-0.5;        
        unknown_to_anchors_dist=hopsize*hop';%计算到锚节点的距离=跳数*校正值
        %~~~~~~~~~~最小二乘法~~~~~~~~~~~~~~~`
        A=2*(all_nodes.estimated(1:all_nodes.anchors_n-1,:)-repmat(all_nodes.estimated(all_nodes.anchors_n,:),all_nodes.anchors_n-1,1));
        anchors_location_square=transpose(sum(transpose(all_nodes.estimated(1:all_nodes.anchors_n,:).^2)));
        dist_square=unknown_to_anchors_dist.^2;
        b=anchors_location_square(1:all_nodes.anchors_n-1)-anchors_location_square(all_nodes.anchors_n)-dist_square(1:all_nodes.anchors_n-1)+dist_square(all_nodes.anchors_n);
        all_nodes.estimated(i,:)=transpose(A\b);
        all_nodes.anc_flag(i)=2;
    end
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    save '../Localization Error/result.mat' all_nodes comm_r;
end