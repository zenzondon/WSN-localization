function Fig_Of_Model(comm_r,DOI)
%~~~~~~~~~~~~~ Research on DOI Model~~~~~~~~~~~
%   draw the radio range whose perdetermined communication radius is comm_r,
%  with that DOI.
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% "DOI denotes the irregularity of the radio. It is defined as the maximun
% radio range variation per unit degree change in the direction of radio
% propagation. When the DOI is set to zero, there is no range variation,
% resulting in a perfectly circular radio model."
% K_1=1; K_i=K_(i-1)+doi; doi~[-DOI,DOI]; |K_360-k_1|<DOI
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% typicl value: DOI=0~0.02(max)  comm_r=80m~100m(120m--max)
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% call format:
% Fig_Of_Model(100,0);   Fig_Of_Model(100,0.005);
% Fig_Of_Model(100,0.01);Fig_Of_Model(100,0.015);
    if DOI==0
        K_i=ones(1,360);
    else    
        K_i(1)=1;
        for i=2:360
            doi=unifrnd(-DOI,DOI,1,1);
            K_i(i)=K_i(i-1)+doi;
        end
        while abs(K_i(1)-K_i(360))>DOI
            for i=2:360
                doi=unifrnd(-DOI,DOI,1,1);
                K_i(i)=K_i(i-1)+doi;
            end
        end
    end
    %~~~~~~~~~~~~draw the radio range
    directory=cd;
    cd ..;
    RSS=dist2rss(comm_r,1);      
    dist=rss2dist(RSS,K_i);
    cd(directory);
    figure;
    hold on;
    box on;
    polar(0:pi/180:2*pi,[dist dist(1)],'k-');
    axis square;
    if DOI~=0
        polar(0:pi/180:2*pi,ones(1,361)*comm_r,'k:');
    end
    title(['DOI Model£ºDOI=',num2str(DOI)]);
end