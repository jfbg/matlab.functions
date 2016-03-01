function OUT = phoBitLimitED50(IN,DIST,TIME)

% OUT = phoBitLimitED50(IN,INoriginal,DIST,TIME)
%           IN is data array to be bit-limited (NT by ND)
%           INoriginal is the noise-free array (NT by ND)
%           DIST is distance vector (1 by ND)
%           TIME is time vector (NT by 1)
%
%           OUT is 10 bit-limited NT by ND array
%
%           the width of 1 bit is the maximum value of signal at 50 deg,
%           divided by 40. See file below for info:
%
%    /Users/jf/Documents/UBC/Moon/Phonon1D/ANALYSIS/DATA/FindAverageSNR.m
%
% Created by JFBG, November 2011
     

tlim = [100 2700];
tempd = IN(TIME > tlim(1) & TIME < tlim(2),DIST == 50);
maxy = max(abs(tempd));

dBit = maxy/40;

OUT = round(IN/dBit)*dBit;

OUT(OUT > 512*dBit) = 512*dBit;

fprintf('%.2f%% of OUT was clipped\n',sum(sum(OUT == 512*dBit))/numel(OUT)*100);

return