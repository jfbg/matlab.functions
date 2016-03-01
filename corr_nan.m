function [RHO,PVAL] = corr_nan(x,y)

% [RHO,PVAL] = corr_nan(x,y)
%
% Same as corr (returns linear correlation coefficient of x and y) but
% takes care of the NaN values (gets rid of them).

xt = x;
yt = y;

xt(isnan(x) == 1 | isnan(y) == 1) = [];
yt(isnan(x) == 1 | isnan(y) == 1) = [];

[RHO,PVAL] = corr(xt,yt);