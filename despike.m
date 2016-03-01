function D1new = despike(D1,lmed,mult)

% function NEWD1 = despike(D1,lmed,mult)
% where D1 is the orignal signal, lmed is the length of the median window
% and mult is the median multiplier.
% 
% DEFAULTS:
% lmed = 500;
% mult = 5;

if nargin == 1
    lmed = 500;
    mult = 5;
elseif nargin == 2
    mult = 5;
end

signD1 = sign(D1);
medD1 = zeros(size(D1));

for i = lmed+1 : length(D1) - lmed
    medD1(i) = median(abs(D1(i-lmed:i+lmed)));
end
ind = find(abs(D1) > mult*medD1);
D1new = abs(D1);
D1new(ind) = mult*medD1(ind);
D1new = D1new .* signD1;


% figure(1),clf
% subplot(211)
% plot(D1)
% hold on
% plot(medD1*10,'r')
% plot(medD1*-10,'r')
% subplot(212)
% plot(D1new)

