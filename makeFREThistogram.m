% use run and advance to run one section at at time

%%
% section 1: this will give you a histogram
% you need variables Acceptors and Donors
GammaFactor=1.0 ;
ChannelLeakage=0.12;
fret=(Acceptors-ChannelLeakage*Donors)./(Acceptors-ChannelLeakage*Donors+Donors);
figure;
hist(fret,[-0.2:0.015:1.2]);
temp=axis;temp(1)=0;temp(2)=1;axis(temp);

%%
% section 2: this will save the file in the current directory
% change the # of the hel file to keep track
% will save only the FRET values
save('hel2_combined steady fret.dat','fret','-ascii');