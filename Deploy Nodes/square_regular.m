function square_regular(square_L,grid_L,deploy_error,anchors_n,GPS_error)
% deploy the sensor nodes over a square sensing region
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% square_L: the length of the side of a square
% divide the square into grids; grid_L is the length of the side of the grid
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
% square_regular(200,20,0,0.1)    
    error=deploy_error*grid_L;
    nodes_n=(floor(square_L/grid_L+1))^2;
    if anchors_n<1
        anchors_n=round(nodes_n*anchors_n);  % translate the ratio
    end    
    if nargin==4
        GPS_error=0;
    end
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    x=0:grid_L:square_L;
    n=length(x);
    y=x';
    x=repmat(x,n,1);
    y=repmat(y,1,n);
    if error~=0
        x_error=[unifrnd(0,error,n,1),unifrnd(-error,error,n,n-2),unifrnd(-error,square_L-x(1,n),n,1)];
        x=x+x_error;
        y_error=[unifrnd(0,error,1,n);unifrnd(-error,error,n-2,n);unifrnd(-error,square_L-y(n,1),1,n)];
        y=y+y_error;
    end
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    all_nodes.grid_L=grid_L;
    all_nodes.square_L=square_L;
    all_nodes.nodes_n=nodes_n;
    all_nodes.anchors_n=anchors_n; 
    rand_index=randperm(nodes_n)';
    all_nodes.true=[x(rand_index),y(rand_index)]; %true coordinates
    GPS_error=unifrnd(0,GPS_error,all_nodes.anchors_n,1);
    error_angle=unifrnd(0,2*pi,all_nodes.anchors_n,1);
    all_nodes.estimated=[all_nodes.true(1:anchors_n,:)+[GPS_error GPS_error].*[cos(error_angle) sin(error_angle)];zeros(nodes_n-anchors_n,2)];     %estimated coordinates; for anchors, .estimated=.true
    all_nodes.anc_flag=[ones(anchors_n,1);zeros(nodes_n-anchors_n,1)];      %0-unresolved unknown; 1-anchor; 2-resolved unknown
    save coordinates.mat all_nodes;
end