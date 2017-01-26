function C_random(area,nodes_n,anchors_n,GPS_error)
% deploy the nodes over a C-shaped region
% area: the sensing region [200 40 40 160]
%   the side is 200m-long, x=40,y=40,y=160: the edge of C-shaped region
% nodes_n: the number of nodes
% anchors_n: the number of anchors
%   if anchors_n<1, it means the ratio;
%   if anchors_n>1, it means the number
% GPS_error:the max location error of anchor raised by GPS, default is 0;
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% C_random([200 40 40 160],150,0.1)
    if anchors_n<1
        anchors_n=round(nodes_n*anchors_n);  % translate the ratio
    end    
    if nargin==3
        GPS_error=0;
    end
    for i=1:nodes_n
        while true
            x=unifrnd(0,area(1),1);
            y=unifrnd(0,area(1),1);
            if x<=area(2) | y<=area(3) | y>=area(4)%判断是否在C型区域内
                all_nodes.true(i,1)=x;
                all_nodes.true(i,2)=y;
                break;
            end
        end
    end
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    all_nodes.area=area;
    all_nodes.square_L=area(1);
    all_nodes.nodes_n=nodes_n;
    all_nodes.anchors_n=anchors_n; 
    GPS_error=unifrnd(0,GPS_error,all_nodes.anchors_n,1);
    error_angle=unifrnd(0,2*pi,all_nodes.anchors_n,1);
    all_nodes.estimated=[all_nodes.true(1:anchors_n,:)+[GPS_error GPS_error].*[cos(error_angle) sin(error_angle)];zeros(nodes_n-anchors_n,2)];     %estimated coordinates; for anchors, .estimated=.true
    all_nodes.anc_flag=[ones(anchors_n,1);zeros(nodes_n-anchors_n,1)];      %0-unresolved normal node; 1-anchor; 2-resolved normal node
    save coordinates.mat all_nodes;
end