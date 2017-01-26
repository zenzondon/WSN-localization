function q=relative_to_absolute(init)
    load maps_and_all_nodes.mat;
    Stretch_x=init(1);
    Stretch_y=init(2);
    rotate_angle_x=init(3);
    rotate_angle_y=init(4);
    vx=init(5);
    vy=init(6);
    difference=relative_map(1:all_nodes.anchors_n,:)*[Stretch_x*cos(rotate_angle_x) Stretch_y*sin(rotate_angle_y);-Stretch_x*sin(rotate_angle_x) Stretch_y*cos(rotate_angle_y)]+repmat([vx vy],all_nodes.anchors_n,1)-all_nodes.estimated(1:all_nodes.anchors_n,:);
    q=transpose(sqrt(sum(transpose(difference.^2))));
end  