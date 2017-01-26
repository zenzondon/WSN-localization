clear;
clc;
close all;
directory=cd;
cd ..;
try
    figure;
    hold on;
    box on;
    axis square;
    RSS=[-120,-125,-140,-145];
    dist=rss2dist(RSS);
    for i=1:length(RSS)
        polar(0:pi/180:2*pi,dist(i)*ones(1,361),'b:');
        text(0,-dist(i),[num2str(RSS(i)),'dBm'],'Color','red');
    end
    figure;
    dist=5:5:200;
    RSS=dist2rss(dist);
    plot(dist,RSS,'b*--');
    xlabel('distance(meter)');
    xlabel('RSS(dBm)');
    title('相邻点的距离相差5m');
catch
    cd(directory);
end
cd(directory);    