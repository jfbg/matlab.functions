function [decD betax] = IRdeconv(in,type,pflag,beta)

% [decD betax] = IRdeconv(in,type,pflag,beta)

% IR deconv will correct signals for the instrument response. The response
% has been generated based on data from the IRIS website. It is stored in
% FCT/IR.mat for all modes of the instrumeds (SP, LPflat, LPpeak).
%
% This is a water-level deconvolution. If no beta (regularization
% parameter) is provided, it will use GCV to calculate most appropriate
% parameter.
%   
% Inputs:
% IN is the signal to deconvolve (1xN). For now, N has to be odd)
% TYPE is the type is signal (SP, LPflat or LPpeak'
% PFLAG is 1 to plot GCV results, and 0 for no plot.
%
%
% Outputs:
%
% decD is deconvolved signal
% betax is regularization parameter used and calculated through GCV.
%
%
% GCV part is from Micheal Bostock's simdec.m


%%
if nargin < 3, pflag = 0; end %Plot GCV
if nargin < 4, beta = []; end

% in = D;
% type = 'lppeak';

% Make in of off length
if mod(length(in),2) == 0,
    in(end) = [];
end


load IR.mat
% Phase is in radian, need to convert to x + i*y

switch lower(type)
    case {'sp'}
        disp('Mode is SP')
        
        % convert from polar to cartesian
        [X,Y] = pol2cart(IR.SP.p,IR.SP.a);
        ir = X + Y*1i;
        dt = 0.018867;
        in = bpfilt(in',dt,2,10,8,1)';
        betarange = -2:.1:5;
        
    case {'lpflat'}
        disp('Mode is LP FLAT')
        
        % convert from polar to cartesian
        [X,Y] = pol2cart(IR.LPflat.p,IR.LPflat.a);
        ir = X + Y*1i;
        dt = 0.15094;
        in = bpfilt(in',dt,.25,2,8,1)'; 
        betarange = -10:.1:5;
        
    case {'lppeak'}
        disp('Mode is LP PEAK')
        
        % convert from polar to cartesian
        [X,Y] = pol2cart(IR.LPpeak.p,IR.LPpeak.a/sum(IR.LPpeak.a));
        ir = X + Y*1i;
        dt = 0.15094;
        in2 = in;
        in = bpfilt(in',dt,.25,2,8,1)'; 
        betarange = -10:.1:5;
        
    otherwise
        error('Must choose a IR type: SP, Flat or Peak');
end



%% Need to add negative frequencies and to zeropad the IR in 
%  the time domain to length of N. frequency 0 is 0 and acts 
%  as the symmetry axis
  
 irft = [conj(flipud(ir(2:end))); ir];
 irft2 = irft;
 
 N = length(in);
 Nir = length(irft);
 % Number of 0s to add on each side of ifft(irft)
 N0 = ((N-1)/2 - (Nir-1)/2);
 
 %Pad with 0s.
 irdt = ifft(irft);
 irdt0 = [zeros(N0,1); irdt; zeros(N0,1)];
 
 %Take Fourier Transform + Denominator and Numeration of WLdeconv
 irft = fft(irdt0);
 vft=fft(in);
 wwftft=irft.*conj(irft);
 vwft=vft.*conj(irft);
 
 %% Compute Appropriate beta for the water-level deconvolution with GCV

 if isempty(beta)  == 1

    beta=exp(betarange);
  for ib=1:length(beta);

% Define operator W W* / (W W* + B) and deconvolve to get response in 
% frequency domain.
   wwft2=irft+beta(ib);
   rft=vwft./wwft2;
   xft=irft./wwft2;

   
% Compute model norm.
   modnorm(ib)=norm(rft)^2; %#ok<*AGROW>

% Compute data misfit. Note misfit is numerator of GCV function.
     nft=vft-irft.*rft;
     misfit(ib)=norm(nft)^2;

% Compute denominator and GCV function. 
   den=N-real(sum(xft));
   den=den*den;
   gcvf(ib)=misfit(ib)/den;
  end
 
% Compute best beta.
 [gc1,ibest]=min(gcvf);
 betax=beta(ibest);
 
 % If minimum not found inform user.
 if ibest == 1 | ibest == length(beta)
   disp('WARNING: No minimum found for GCV')
   disp('change search limits')
   disp('index at minimum and no of seismograms');
 end
 
 else betax = beta;
 end
 
 %% If plot of GCV and L-curve are desired.
 if pflag == 1
   figure(99)
   subplot(2,1,1)
   plot(modnorm,misfit,'b')
   hold on
   plot(modnorm,misfit,'r+')
   plot(modnorm(ibest),misfit(ibest),'go')
   hold off
   xlabel('Model Norm')
   ylabel('Data Misfit')
   subplot(2,1,2)
   semilogx(beta,gcvf)
   hold on
   semilogx(beta,gcvf,'r+')
   semilogx(beta(ibest),gcvf(ibest),'go')
   hold off
   xlabel('Regularization Parameter')
   ylabel('GCV Function')
%    pause
 end
  
 
%% Final estimate.
wwft2=irft+betax;
rft=vwft./wwft2; %The one you want
xft=irft./wwft2;
rt=real(ifft(rft));
xt=real(ifft(xft));
 
 figure(1)
 clf
 subplot(211)
 plot(abs(irft((N-1)/2-1:end)))
 subplot(212)
 [Pxx,Pxxc,w2] = pmtm(detrend(in),[],[],1/dt,0.99);
 plot(Pxx)
 %%
 
 decD = nan(size(rt));
 decD(1:(length(rt)-1)/2) = rt((length(rt)-1)/2+2:end);
 decD((length(rt)-1)/2+1:end) = rt(1:(length(rt)-1)/2+1);
 
%  xl = [4700 6400];
 
 figure(2)
 clf
 subplot(311)
 plot((1:length(in))*dt,in)
%  xlim(xl)
 subplot(312)
 plot((1:length(in))*dt,decD)
%  xlim(xl)
 subplot(313)
 plot((1:length(in))*dt,rt)
%  xlim(xl)
 
 
 
 %%
% figure(3)
% clf
% % [Pxx,Pxxc,w2] = pmtm(detrend(in),[],[],1/dt,0.99);
% hpsd = dspdata.psd([Pxx],'Fs',1/dt);
% subplot(211)
% plot(hpsd)
% [Pxx,Pxxc,w2] = pmtm(detrend(rt),[],[],1/dt,0.99);
% hpsd = dspdata.psd([Pxx],'Fs',1/dt);
% subplot(212)
% plot(hpsd)

% % % figure(4)
% % % subplot(121)
% % % subplot(212)
% % % plot(hpsd)
% % % % subplot(223)
% % % % plot(linspace((0:(N-1)/2),irft((N-1)/2-1:end)))
 
 %%


