function [p s pol coeff] = findPS(D1,cluster,station,channel)
% [p s pol coeff] = findPS(D,cluster,station,channel)
%
% p & s are ToA_p and ToA_s
% pol is polarity of signal.
% coeff is maximum correlation coefficient
%
% D is signal
% cluster has format A--- (eg. A001)
% station is 12, 14, 15 or 16
% channel is string ('lpx', 'lpy' 'lpz' or 'spz')
%
% All outputs are -99 if no stack for this particular cluster and station exist
%
% Last updated: 2009/12/04
%
%% Load Stack

stackname = sprintf('A%03.0f_%2.0f_%s',cluster,station,channel);

% Get stack folder
load STACK_folder.mat

if exist([STACK_folder stackname '.mat']) ~= 2
    p = -99;
    s = -99;
    pol = -99;
    coeff = -99;
    
else
% Load stack + difference (in sample interval) between S and P (dT)
load([STACK_folder stackname '.mat']);

% Give the stack the "stack" variable name.
eval(['stack = ' stackname ';'])

%%

stacktemp = zeros(size(D1));
stacktemp(1:length(stack)) = stack;
stack = stacktemp;


%%
Correl = xcorr(D1,stack);
lag = -(length(Correl)-1)/2:(length(Correl)-1)/2;

imaxp = lag(abs(Correl) == max(abs(Correl)));
imaxs = imaxp + dT;

p = imaxp;
s = imaxs;

pol = sign(Correl(abs(Correl) == max(abs(Correl))));


coeff = abs(Correl(abs(Correl) == max(abs(Correl)))/(sqrt(D1'*D1)*sqrt(stack'*stack)));


 
%{
if imaxp >= 0 
    
    
% S-Wave
maxsCCov = 0;
k = 0;
while maxsCCov ~= N
    if k > 10, break, end
    
    sd1 = D1(imaxs-winstart:imaxs+N-winstart-1)';
    sa1 = A64x(1827-winstart:1827+N-winstart-1)';

    sCCov = xcorr(sd1,sa1);

    maxsCCov = find(((abs(sCCov))) == max(abs(sCCov)));

    imaxs = imaxs - N + maxsCCov;

    k = k+1;
end




% P-Wave
maxpCCov = 0;
k = 0;
while maxpCCov ~= N
    if k > 5, imaxp = imaxs-dT; break, end

    if imaxp <= winstart && imaxp >= 0
        pd1 = D1(imaxp:imaxp+N)';
        pa1 = A64x(1077:1077+N)';
    elseif imaxp > winstart
        pd1 = D1(imaxp-winstart:imaxp+N-winstart-1)';
        pa1 = A64x(1077-winstart:1077+N-winstart-1)';
    end

    pCCov = xcorr(pd1,pa1);

    maxpCCov = find(((abs(pCCov))) == max(abs(pCCov)));

    imaxp = imaxp - N + maxpCCov;
    
%     if abs(maxpCCov-N) <= N
%         imaxp = imaxp - N + maxpCCov;
%     elseif abs(maxpCCov-N) > N
%         imaxp = 'E';
%         break
%     end
    k = k+1;
end
elseif imaxp < 0
    imaxp = 'E';

end



% % % % Finding highest corr-coefficient
% % % pd1 = D1(imaxp-winstart:imaxp+N-winstart-1)';
% % % pa1 = A64x(3064-winstart:3064+N-winstart-1)';
% % % sd1 = D1(imaxs-winstart:imaxs+N-winstart-1)';
% % % sa1 = A64x(3814-winstart:3814+N-winstart-1)';
% % % 
% % % p_ncoeff = sqrt(sum(pd1.^2)) * sqrt(sum(pa1.^2));
% % % s_ncoeff = sqrt(sum(sd1.^2)) * sqrt(sum(sa1.^2));
% % % 
% % % maxp = max(abs(xcorr(pd1,pa1)/p_ncoeff));
% % % maxs = max(abs(xcorr(sd1,sa1)/s_ncoeff));


% PLOT CORRELATION COEFFICIENTS
% % % % % % % figure(20)
% % % % % % % plot(abs(xcorr(pd1,pa1)/p_ncoeff))
% % % % % % % title('P')
% % % % % % % figure(21)
% % % % % % % plot(abs(xcorr(sd1,sa1)/s_ncoeff))
% % % % % % % title('S')

% if d1type == 0
%     if maxp >= maxs
%         p = imaxp;
%         s = imaxp + dT;
%         dtype = 1;
%     elseif maxp < maxs
%         s = imaxs;
%         p = imaxs - dT;
%         dtype = 2;
%     end
% elseif d1type == 1
%     p = imaxp;
%     s = imaxp + dT;
%     dtype = 1;
% elseif d1type == 2
%     s = imaxs;
%     p = imaxs - dT;
%     dtype = 2;
% end

p = imaxp;
if p < 0
    p = 'E';
end
s = imaxs;
% dtype = 0;
%}
end
return

