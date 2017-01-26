clear;
clc;
close all;
directory=cd;
cd ..;
try
    figure;
    hold on;
    grid on;
    box on;
    dist=5:5:100;
    [RSS,RSS_NOFADING]=dist2rss(dist);
    plot(dist,RSS,'-b*',dist,RSS_NOFADING,'-rd');
    xlabel('distance(meter)');
    ylabel('RSS(dBm)');
    legend('logarithmic attenuation model','regular model');
    %~~~~~~~~~~~~~~~~~~~~~~~~
    figure;
    hold on;
    box on;
    axis square;
    comm_r=[30;80];
    dist=repmat(comm_r,1,360);
    polar(0:pi/180:2*pi,[dist(1,:),dist(1,1)],'--k');
    polar(0:pi/180:2*pi,[dist(2,:),dist(2,1)],':k');
    RSS=dist2rss(dist);
    dist=rss2dist(RSS);    
    polar(0:pi/180:2*pi,[dist(1,:),dist(1,1)],'-b*');
    polar(0:pi/180:2*pi,[dist(2,:),dist(2,1)],'-rd');
    legend('30m Disc','80m Disc','RSS为Pr(30)的点','RSS为Pr(80)的点');
    %~~~~~~~~~~~~~~~~~~~~~~~~
    figure;
    hold on;
    box on;
    comm_r=10:10:100;
    dist=repmat(comm_r,360,1);
    RSS=dist2rss(dist);
    dist=rss2dist(RSS);  
    bar(comm_r,mean(dist),0.3,'w');
    errorbar(comm_r,mean(dist),mean(dist)-min(dist),max(dist)-mean(dist),'b.');
    plot(comm_r,sqrt(sum((dist-repmat(mean(dist),360,1)).^2)),'-rd');
    axis auto;
    legend('RSS为Pr(X)的点到发送节点的平均距离','RSS为Pr(X)的点到发送节点的最近/远距离','RSS为Pr(X)的点到发送节点距离的标准差');
    title('可见:距离发送节点越远，RSS相同的点距离差异越大');
    set(gca,'XTick',comm_r);
    set(gca,'XTickLabel',num2cell(comm_r));    
    %~~~~~~~~~~~~~~~~~~~~~~~~
    %~~~~~~~PS:
    %    logarithmic attenuation model是由Regular model加上Fading component of
    % RSS得到的。
    %    模型介绍具体见~/Transmission Model/readme.bmp和Models_Soln_RIM_TOSN.pdf
    %    该模型下距离发送节点越远的接受节点受到Fading componen的影响相对较大。
    %    毕竟距离在10m以内，一米的距离变化可导致几十db的信号衰落，Fading component几db的影响相对较小。
    %    在100m以外，10米的距离变化也不过才几db的信号衰落，这时Fading component几db的影响相对而言是很大的。
    %~~~~~~~~~~~~~~~~~~~~~~~~
catch
    disp('ERROR');
    cd(directory);
end
%~~~~~~~~~~~~~~~~~~~~~~~~
cd(directory);