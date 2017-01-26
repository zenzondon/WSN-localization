function dist=rss2dist(RSS,K_i)
%~~~~~~~~~~~~~~~~~~~~~~DOI Model~~~~~~~~~~~~~~~
%   T. He et.al proposed the original DOI Model in  
% "Rang-Free Localization Schemes for Large Scale Sensor Networks"
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%   Different from the original DOI Model, this model does not have
% the upper and lower bound of the communication range.
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% "DOI denotes the irregularity of the radio. It is defined as the maximun
% radio range variation per unit degree change in the direction of radio
% propagation. When the DOI is set to zero, there is no range variation,
% resulting in a perfectly circular radio model."
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% ReceivedSignalStrength=SendingPower-DOIAdjustedPathLoss
% e.g, RSS=Pt-Pl(d0)-10*¦Ç*log10(dist/d0)*Ki
% Pt:transmit power
% pl(d0):the pass loss for a reference distance of d0
% ¦Çis the path loss exponent
% above parameters are saved in '../Parameters_Of_Models.mat'
% K_i=K_(i-1)+doi; doi~[-DOI,DOI]; 
% dist:distance between sender and receiver(m)
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% typical value:Pt=0-4dBm(max),Pl(d0)=55dB(d0=1m),¦Ç(2~4)=4(indoor,outdoor)
    load '../Parameters_Of_Models.mat';
    dist=d0*10.^((Pt-Pl_d0-RSS)./(10*eta*K_i));
end
