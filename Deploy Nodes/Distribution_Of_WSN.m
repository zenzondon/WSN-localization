load coordinates.mat;
figure;
hold on;
box on;
plot(all_nodes.true(1:all_nodes.anchors_n,1),all_nodes.true(1:all_nodes.anchors_n,2),'r*');
plot(all_nodes.true(all_nodes.anchors_n+1:all_nodes.nodes_n,1),all_nodes.true(all_nodes.anchors_n+1:all_nodes.nodes_n,2),'bo');
axis([0,all_nodes.square_L,0,all_nodes.square_L]);
title('节点分布图');
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
try %画出C型区域的边界
    square_L=all_nodes.square_L;
    area=all_nodes.area;
    plot([area(2) area(2)],[area(3) area(4)],'-k',[area(2) square_L],[area(3) area(3)],'-k',[area(2) square_L],[area(4) area(4)],'-k');    
catch
   %none 
end
disp('~~~~~~~~~~~~~~~~~~~~~~~~节点分布图~~~~~~~~~~~~~~~~~~~~~~~~~~');
disp([num2str(all_nodes.nodes_n),'个节点,','其中',num2str(all_nodes.anchors_n),'个锚节点']);
disp('红色*表示锚节点，蓝色O表示未知节点');