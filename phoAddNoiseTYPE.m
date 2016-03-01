function OUT = phoAddNoiseTYPE(IN,DIST,TIME,type,chan)

% OUT = phoAddNoiseDMQ50(IN,SNR,K)
%           IN is array of synthethic signals (NT x ND)
%           DIST
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
    if chan == 4
        SNR = 4.98;    
    else
        SNR = 4.3;
    end
elseif strcmp(type,'SMQ') == 1
    ED = 68;
    if chan == 4
        SNR = 15.08;    
    else
        SNR = 14.28;
    end
elseif strcmp(type,'NI') == 1
    ED = 42;
    if chan == 4
        SNR = 8.01;    
    else
        SNR = 10.46;
    end
else
    error('This function works only for DMQ, SMQ and NI.')
end


tlim = [100 3600];
tempd = IN(TIME > tlim(1) & TIME < tlim(2),DIST == ED);
maxy = max(abs(tempd));
bit = maxy/SNR;


       
OUT = nan(size(IN));

for cc = 1:size(IN,2)
    noisetemp = wgnJF(length(IN),1,0);
    noise = noisetemp/max(abs(noisetemp))*bit;
    OUT(:,cc) = IN(:,cc) + noise;
end
        
% fprintf('Noise added, sigpower = %.4f dB, maxindex is
% %.0f\n',sigpower,maxindex);
 
%%
return