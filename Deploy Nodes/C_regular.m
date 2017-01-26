function C_regular(area,grid_L,deploy_error,anchors_n,GPS_error)
% deploy the nodes over a C-shaped region
% area: the sensing region [200 40 40 160]
% divide the C-shaped region into grids; grid_L is the length of the side of the grid
% all the nodes are distributed at the grid point.
% deploy_error: the difference between the grid point and the actual
%   position of the sensor node, expressed as grid_L*deploy_error. <0.5
% nodes_n: the number of nodes, including anchors and normal nodes
%   according to square_L and grid_L, it can be determined
% anchors_n: the number of anchors
%   if anchors_n<1, it means the ratio;
%   if anchors_n>1, it means the number
% GPS_error:the max location error of anchor raised by GPS, default is 0;
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% C_regular([200 40 40 160],10,0,0.1)
    error=deploy_error*grid_L;    
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~先在正放形区域内分布，然后再选择在C型区域内的点
    x=0:grid_L:area(1);
    n=length(x);
    in_x=find(x<=area(2));
    y=x';
    in_y1=find(y<=area(3));
    in_y2=find(y>=area(4));
    x=repmat(x,n,1);
    y=repmat(y,1,n);    
    x_at_edge=[1,length(in_x),n];
    x_not_at_edge=setdiff(1:n,x_at_edge);
    y_at_edge=[1,length(in_y1),in_y2(1),n];
    y_not_at_edge=setdiff(1:n,y_at_edge);
    if error~=0
        x_error(:,x_at_edge)=[unifrnd(0,error,n,1),unifrnd(-error,area(2)-x(1,length(in_x)),n,1),unifrnd(-error,0,n,1)];
        x_error(:,x_not_at_edge)=unifrnd(-error,error,n,length(x_not_at_edge));
        y_error=zeros(n);
        y_error(y_at_edge,:)=[unifrnd(0,error,1,n);unifrnd(-error,area(3)-y(length(in_y1)),1,n);unifrnd(area(4)-y(in_y2(1)),error,1,n);unifrnd(-error,0,1,n)];
        y_error(y_not_at_edge,:)=unifrnd(-error,error,length(y_not_at_edge),n);     
        x=x+x_error;
        y=y+y_error;
    end
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%选择在C型区域内的点    
    nodes_n=n*(length(in_y1)+length(in_y2))+length(in_x)*(n-length(in_y1)-length(in_y2));
    if anchors_n<1
        anchors_n=round(nodes_n*anchors_n);  % translate the ratio
    end   
    if nargin==4
        GPS_error=0;
    end
    a=repmat(n*(length(in_x)+1)+1-[in_y1',in_y2'],n-length(in_x),1)+repmat(transpose(0:n:n*(n-length(in_x)-1)),1,length([in_y1',in_y2']));
    [b,c]=size(a);
    index=[1:n*length(in_x),reshape(a,1,b*c)];%C型区域内的点的索引
    all_nodes.true=[x(index'),y(index')];
    rand_index=randperm(length(index))';
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    all_nodes.area=area;
    all_nodes.grid_L=grid_L;
    all_nodes.square_L=area(1);
    all_nodes.nodes_n=nodes_n;
    all_nodes.anchors_n=anchors_n; 
    all_nodes.true=all_nodes.true(rand_index,:); %true coordinates
    GPS_error=unifrnd(0,GPS_error,all_nodes.anchors_n,1);
    error_angle=unifrnd(0,2*pi,all_nodes.anchors_n,1);
    all_nodes.estimated=[all_nodes.true(1:anchors_n,:)+[GPS_error GPS_error].*[cos(error_angle) sin(error_angle)];zeros(nodes_n-anchors_n,2)];     %estimated coordinates; for anchors, .estimated=.true
    all_nodes.anc_flag=[ones(anchors_n,1);zeros(nodes_n-anchors_n,1)];      %0-unresolved unknown; 1-anchor; 2-resolved unknown
    save coordinates.mat all_nodes;
end