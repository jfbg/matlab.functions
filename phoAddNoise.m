function [OUT,bit,ED,tlim] = phoAddNoise(IN,DIST,TIME,type,freq,bitlevel)

% OUT = phoAddNoise(IN,TIME,type,chan)
%           IN is array of synthethic signals (NT x ND)
%           TIME is time array
%           type is one of: NI,SMQ,DMQ
%           freq is 7 or 40
%           OUT is also NT x ND
%  
%
% phoAddNoise is used to add 1 bit white gaussian noise to compiled outputs of
% the PHONON1D synthethic code. The input must be NT x ND, where NT is the
% number of time intervals in the signal and ND the number of epicentral
% distances.
%
% Amplitude of 1 bit is:
%
%   Max amplitude of event at ED deg / SNR and varies for each events.
%
%   This was determined based on SNR values for each each event type
%   See
%   /Users/jf/Documents/UBC/Moon/Phonon1D/ANALYSIS/DATA/FindAverageSNR.m
%
% Created by JFBG, November 2011
% Modified by JFBG, June 2013
      
%%

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


% tlim = [100 3600];
if isnan(bitlevel) == 1
    tempd = IN(:,DIST == ED);
    figure(1)
    clf
    plot(TIME,tempd);
    [xt yt] = ginput(2);
    tlim = [min(xt) max(xt)];
    tempd = IN(TIME > tlim(1) & TIME < tlim(2),DIST == ED);
    maxy = rms(tempd);
%    maxy = max(abs(tempd));    
    bit = maxy/SNR;
else
    bit = bitlevel;
    tlim = NaN;
end

       
OUT = nan(size(IN));

for cc = 1:size(IN,2)
    noisetemp = wgnJF(length(IN),1,0);
    noise = noisetemp/mode(noisetemp)*bit;
    OUT(:,cc) = IN(:,cc) + noise;
end

fprintf('%s - %.0f Hz - ED = %.0fdeg - SNR = %.2f ----  1 bit = %.4f\n',type,freq,ED,SNR,bit);
        
% fprintf('Noise added, sigpower = %.4f dB, maxindex is
% %.0f\n',sigpower,maxindex);
 
%%


return