function [out,w,filt] = filtsig_LP(in,dt,wc,np)


% out = filtsig_LP(in,dt,wc,np)
% 
% Butterworth Low-Pass filter
% 
% in is data
% dt is sampling interval
% wc is cut-off frequency
% np is number of poles

% % % %% TESTING
% % % 
% % % clear all
% % % [t d] = getGFS(19721611652,12,'lpx');
% % % 
% % % d = d(300:19000);
% % % t = t(300:19000);
% % % 
% % % % figure(1), plot(t,d)
% % % 
% % % in = d;
% % % dt = .150937498;
% % % wc = 1/1.2;
% % % np = 4;
%%

[nr nc] = size(in);

if nr > nc, in = in'; end


len = length(in);
T = length(in)*dt;

if mod(length(in),2) == 0
    wt = (1:length(in)/2) * 1/T;
    w = [fliplr(wt(1:end))*-1 0 wt(1:end-1)];
else
    wt = (1:(length(in)-1)/2) * 1/T;
    w = [fliplr(wt(1:end))*-1 0 wt(1:end)];
end


filt = 1./(1+(w/wc).^(2*np));
out = (ifft(ifftshift(fftshift(fft(in))/length(in).*filt)));

if nr > nc, out = out'; end


%{
figure(2)
subplot(211)
plot(in)
subplot(212)
plot(filtsig)

%%
figure(3)
subplot(121)
plot(w,abs(fftshift(fft(detrend(d)))))
xlim([0 max(w)])
subplot(122)
plot(w,abs(fftshift(fft(detrend(filtsig)))))
xlim([0 max(w)])
%}