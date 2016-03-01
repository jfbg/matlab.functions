function [w2 Pxx p] = plotspec(in,dt)

% [w ff h] = plotspec(in,dt)
%
% Plot Frequency Spectra (uses multitapers)

%{
% h = figure;
% in = in(:);
in = detrend(in(:));

if WINDOW == 1
win = hann(length(in));
else
  win = ones(size(in));
end

w = makefreqvector(length(in),dt*length(in),dt);

ff = 2*fftshift(fft(win(:).*in))/length(in);

plot(w,abs(ff))
xlim([0 max(w)])
%}

[Pxx,Pxxc,w2] = pmtm(detrend(in),[],[],1/dt,0.99);
% hpsd = dspdata.psd([Pxx Pxxc],'Fs',1/dt);
% hpsd = dspdata.psd([Pxx],'Fs',1/dt);
hpsd = dspdata.msspectrum([Pxx],'Fs',1/dt);
% subplot(1,7,[1 2 3])
p = plot(hpsd);
% subplot(1,7,[4 5])
% plot(hpsd)
% xlim([0 .25])
% subplot(1,7,[6 7])
% plot(hpsd)
% xlim([0 .1])


%}