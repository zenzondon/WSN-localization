function square_random(square_L,nodes_n,anchors_n,GPS_error)
% deploy the sensor nodes over a square sensing region
% square_L: the length of the side of a square
% nodes_n: the number of nodes, including anchors and normal nodes
% anchors_n: the number of anchors
%   if anchors_n<1, it means the ratio;
%   if anchors_n>1, it means the number
% GPS_error:the max location error of anchor raised by GPS, default is 0;
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`
% square_random(200,200,0.1)
    if anchors_n<1
        anchors_n=round(nodes_n*anchors_n);  % translate the ratio
    end
    if nargin==3
        GPS_error=0;
    end
    all_nodes.square_L=square_L;
    all_nodes.nodes_n=nodes_n;
    all_nodes.anchors_n=anchors_n;    
    all_nodes.true=unifrnd(0,square_L,nodes_n,2); %true coordinates
    GPS_error=unifrnd(0,GPS_error,all_nodes.anchors_n,1);
    error_angle=unifrnd(0,2*pi,all_nodes.anchors_n,1);
    all_nodes.estimated=[all_nodes.true(1:anchors_n,:)+[GPS_error GPS_error].*[cos(error_angle) sin(error_angle)];zeros(nodes_n-anchors_n,2)];     %estimated coordinates; for anchors, .estimated=.true
    all_nodes.anc_flag=[ones(anchors_n,1);zeros(nodes_n-anchors_n,1)];      %0-unresolved unknown; 1-anchor; 2-resolved unknown
    save coordinates.mat all_nodes;
end
