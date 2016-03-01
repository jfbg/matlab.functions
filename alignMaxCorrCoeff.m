function [nD1 nD2 maxc lag] = alignMaxCorrCoeff(D1,D2)

% [nD1 nD2 maxc lag] = alignMaxCorrCoeff(D1,D2);
% 
% Align two signals on their maximum correlation coefficient (maxC).
%
% Inputs:   D1, D2, the two signals to align
% Outputs:  nD1, nD2, the aligned signals
%           maxc is maximum correlation coefficient
%           lag is lag between two events.
%
% NOTE: THIS DOES NOT CORRECT FOR NEGATIVE POLARITY

D1 = D1(:)';
D2 = D2(:)';

[c lags] = xcorr(D1,D2);

% Lag at maximum correlation coefficient
lagmax = lags(abs(c) == max(abs(c)));


maxlength = max([length(D1) length(D2)]);
nD1 = zeros(1,maxlength+abs(lagmax));
nD2 = zeros(1,maxlength+abs(lagmax));


if lagmax > 0
    nD1(1:length(D1)) = D1;
    nD2(abs(lagmax)+1:length(D2)+abs(lagmax)) = D2;
elseif lagmax < 0
    nD1(abs(lagmax)+1:length(D1)+abs(lagmax)) = D1;    
    nD2(1:length(D2)) = D2;
elseif lagmax == 0
    nD1(1:length(D1)) = D1;
    nD2(1:length(D2)) = D2;
end  
 
lag = lagmax;
maxc = c(abs(c) == max(abs(c)));
        
 