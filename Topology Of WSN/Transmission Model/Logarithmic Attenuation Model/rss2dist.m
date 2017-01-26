function dist=rss2dist(RSS)
%~~~~~~~~Logarithmic Attenuation Model~~~~~~~~~
%   In this model, the radio range is a circle
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% ReceivedSignalStrength=SendingPower-PathLoss+Fading
% e.g, RSS=Pt-Pl(d0)-10*灰*log10(dist/d0)+X考
% Pt:transmit power
% pl(d0):the pass loss for a reference distance of d0
% 灰is the path loss exponent
% X考:Gaussian random variable of zero mean and 考^2variance N(0,考^2) 考=4~10
% above parameters are saved in '../Parameters_Of_Models.mat'
% dist:distance between sender and receiver(m)
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% mean(X考)=0, needn't take it into consideration when translating RSS to distance 
% ==>dist=d0*10.^((Pt-Pl_d0-RSS)./(10*eta))   
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% typical value:Pt=0-4dBm(max),Pl(d0)=55dB(d0=1m),灰(2~4)=4(indoor,outdoor)
    load '../Parameters_Of_Models.mat';
    dist=d0*10.^((Pt-Pl_d0-RSS)./(10*eta));
end
