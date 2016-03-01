function OUT = phoAddNoiseED50(IN,DIST,TIME)

% OUT = phoAddNoiseDMQ50(IN,SNR,K)
%           IN is array of synthethic signals (NT x ND)
%           DIST
%           OUT is also NT x ND
%  
%
% phoAddNoiseDMQ50 is used to 1 bit add white gaussian noise to compiled outputs of
% the PHONON1D synthethic code. The input must be NT x ND, where NT is the
% number of time intervals in the signal and ND the number of epicentral
% distances.
%
% Amplitude of 1 bit is:
%
%   Max amplitude of event at 50 deg / 10
%
%   This was empirically determined based on average DMQ event at 50 deg.
%   See
%   /Users/jf/Documents/UBC/Moon/Phonon1D/ANALYSIS/DATA/FindAverageSNR.m
%
% Created by JFBG, November 2011
      
%%

tlim = [100 2700];
tempd = IN(TIME > tlim(1) & TIME < tlim(2),DIST == 50);
maxy = max(abs(tempd));
bit = maxy/40;


       
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