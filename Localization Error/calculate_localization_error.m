function [Localization_error,Unresolve_num]=calculate_localization_error()
% 画出定位算法的定位结果图
% 锚节点不存在定位误差,用红色*表示,
% 未知节点有的能被定位(蓝色O表示这些节点的估计位置,蓝色-表示这些节点的估计位置到真实位置的误差)
% 未知节点有的不能被定位(黑色O表示,这些节点不存在定位误差)
% Localization_error:平均定位误差--估计位置到真实位置的欧式距离与通信半径的比值
% Unresolved_num:网络中有些孤立点或者因为邻居较少不能被定位，这些点的数目
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    load result.mat;
    figure;
    hold on;
    box on;
    plot(all_nodes.true(1:all_nodes.anchors_n,1),all_nodes.true(1:all_nodes.anchors_n,2),'r*');%the anchors
    Unresolved_unknown_nodes_index=find(all_nodes.anc_flag==0);%the unresolved unknown nodes
    Unresolved_num=length(Unresolved_unknown_nodes_index);
    plot(all_nodes.true(Unresolved_unknown_nodes_index,1),all_nodes.true(Unresolved_unknown_nodes_index,2),'ko');
    resolved_unknown_nodes_index=find(all_nodes.anc_flag==2);%estimated locations of the resolved unkonwn nodes
    plot(all_nodes.estimated(resolved_unknown_nodes_index,1),all_nodes.estimated(resolved_unknown_nodes_index,2),'bo');
    plot(transpose([all_nodes.estimated(resolved_unknown_nodes_index,1),all_nodes.true(resolved_unknown_nodes_index,1)]),...
        transpose([all_nodes.estimated(resolved_unknown_nodes_index,2),all_nodes.true(resolved_unknown_nodes_index,2)]),'b-');
    axis auto;
    title('定位误差图');    
    try %画出规则分布的网格线
        x=0:all_nodes.grid_L:all_nodes.square_L;
        set(gca,'XTick',x);
        set(gca,'XTickLabel',num2cell(x));
        set(gca,'YTick',x);
        set(gca,'YTickLabel',num2cell(x));
        grid on;
    catch
        %none
    end    
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    disp('~~~~~~~~~~~~~~~~~~~~~~~~定位误差图~~~~~~~~~~~~~~~~~~~~~~~~~~');
    disp('红色*表示锚节点');
    disp('蓝色O表示未知节点的估计位置');
    disp('黑色O表示不能被定位的未知节点');
    disp('蓝色-表示未知节点的定位误差(连接未知节点的估计位置和真实位置)');
    disp(['一共',num2str(all_nodes.nodes_n),'个节点:',num2str(all_nodes.anchors_n),'个锚节点,',...
        num2str(all_nodes.nodes_n-all_nodes.anchors_n),'个未知节点,',num2str(Unresolved_num),'个不能被定位的未知节点']);
    Localization_error=sum(sqrt(sum(transpose((all_nodes.estimated(resolved_unknown_nodes_index,:)-all_nodes.true(resolved_unknown_nodes_index,:)).^2))))/...
        (length(resolved_unknown_nodes_index)*comm_r);
    disp(['定位误差为',num2str(Localization_error)]);
end