function dist=rss2dist(RSS)
%~~~~~~~~~~~~~~~~~~~~~~Regular Model~~~~~~~~~~~~~~~
%   In this model, the radio range is a circle
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% ReceivedSignalStrength=SendingPower-PathLoss
% e.g, RSS=Pt-Pl(d0)-10*¦Ç*log10(dist/d0)
% Pt:transmit power
% pl(d0):the pass loss for a reference distance of d0
% ¦Çis the path loss exponent
% above parameters are saved in '../Parameters_Of_Models.mat'
% dist:distance between sender and receiver(m)
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% typical value:Pt=0-4dBm(max),Pl(d0)=55dB(d0=1m),¦Ç(2~4)=4(indoor,outdoor)
    load '../Parameters_Of_Models.mat';
    dist=d0*10.^((Pt-Pl_d0-RSS)./(10*eta));
end
