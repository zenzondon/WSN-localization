function calculate_neighbor(comm_r,anchor_comm_r,model,DOI)
% comm_r:通信半径
% anchor_comm_r:锚节点的通信半径是未知节点通信半径的倍数
% model:选择的通信模型
% DOI：不规则度，model为 'DOI Model','RIM Model'时有效,否则可缺省
    load '../Deploy Nodes/coordinates.mat';
    load 'Transmission Model/Parameters_Of_Models.mat';
    directory=cd;
    if nargin==2
        model='Regular Model';
    end
    cd(['Transmission Model/Regular Model']);
    RSS_threshold=dist2rss(comm_r);
    SendingPower=RSS_threshold+Pl_d0+10*eta*log10(comm_r*anchor_comm_r/d0);
    cd(['../',model]);
    try
        for i=1:all_nodes.nodes_n
            dist=sqrt(sum(transpose((repmat(all_nodes.true(i,:),all_nodes.nodes_n-1,1)-all_nodes.true([1:i-1,i+1:all_nodes.nodes_n],:)).^2)));
            RSS=dist2rss(dist);
            if i<=all_nodes.anchors_n
                RSS(1:all_nodes.anchors_n-1)=RSS(1:all_nodes.anchors_n-1)+(SendingPower-Pt);
            else
                RSS(1:all_nodes.anchors_n)=RSS(1:all_nodes.anchors_n)+(SendingPower-Pt);
            end
            neighbor_i=RSS>RSS_threshold;
            neighbor_matrix(i,:)=[neighbor_i(1:i-1),0,neighbor_i(i:all_nodes.nodes_n-1)];
            neighbor_rss(i,:)=[RSS(1:i-1),SendingPower,RSS(i:all_nodes.nodes_n-1)];        
        end
    catch
        for i=1:all_nodes.nodes_n
            dist=sqrt(sum(transpose((repmat(all_nodes.true(i,:),all_nodes.nodes_n-1,1)-all_nodes.true([1:i-1,i+1:all_nodes.nodes_n],:)).^2)));
            if DOI==0
                K_i=ones(1,all_nodes.nodes_n-1);
            else                
                K(1)=1;
                for k=2:360
                    doi=unifrnd(-DOI,DOI,1,1);
                    K(k)=K(k-1)+doi;
                end
                while abs(K(1)-K(360))>DOI
                    for k=2:360
                        doi=unifrnd(-DOI,DOI,1,1);
                        K(k)=K(k-1)+doi;
                    end
                end
                K_i=K(unidrnd(360,1,all_nodes.nodes_n-1)); 
            end
            RSS=dist2rss(dist,K_i);
            if i<=all_nodes.anchors_n
                RSS(1:all_nodes.anchors_n-1)=RSS(1:all_nodes.anchors_n-1)+(SendingPower-Pt);
            else
                RSS(1:all_nodes.anchors_n)=RSS(1:all_nodes.anchors_n)+(SendingPower-Pt);
            end
            neighbor_i=RSS>RSS_threshold;
            neighbor_matrix(i,:)=[neighbor_i(1:i-1),0,neighbor_i(i:all_nodes.nodes_n-1)];
            neighbor_rss(i,:)=[RSS(1:i-1),SendingPower,RSS(i:all_nodes.nodes_n-1)];
        end
    end
    cd(directory);
    try
        save neighbor.mat neighbor_matrix neighbor_rss comm_r anchor_comm_r model DOI;
    catch
        save neighbor.mat neighbor_matrix neighbor_rss comm_r anchor_comm_r model;
    end
end