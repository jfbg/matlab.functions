function [OUT,dBit] = phoBitLimit(IN,TIME,DIST,dBit,tlim,type,freq)

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
% Modified by JFBG, June 2013

if strcmp(type,'DMQ') == 1
    ED = 34;
    if freq == 40
        SNR = 4.98;
    else
        SNR = 4.3;
    end
elseif strcmp(type,'NI') == 1
    ED = 42;
    if freq == 40
        SNR = 8.01;
    else
        SNR = 10.46;
    end
elseif strcmp(type,'SMQ') == 1
    ED = 68;
    if freq == 40
        SNR = 15.08;
    else
        SNR = 14.28;
    end
else
    error('Type had to be SMQ, DMQ or NI only. Type is: %s',type);
end

if isnan(dBit) == 1
    tempd = IN(TIME > tlim(1) & TIME < tlim(2),DIST == ED);
    maxy = rms(abs(tempd));
    dBit = maxy/(SNR);
%     maxy = max(abs(tempd));
%     dBit = maxy/(SNR*4);
end

disp(dBit)

for cc = 1:size(IN,2)
    noisetemp = wgnJF(length(IN),1,0);
    noise = noisetemp/mode(noisetemp)*dBit;
    OUT(:,cc) = IN(:,cc) + noise;
end

OUT = round(OUT/dBit)*dBit;
% OUT = IN;
OUT(abs(OUT) > 512*dBit) = sign(OUT(abs(OUT) > 512*dBit))*512*dBit;

fprintf('%.2f%% of OUT was clipped\n',sum(sum(OUT == 512*dBit))/numel(OUT)*100);

return