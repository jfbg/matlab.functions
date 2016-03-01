function [idPS pmax smax] = findSP_t(ii,T1,D1,T2,D2,p1,s1,p2,s2,dt,N,...
                    winstart,int_factor,interp_style,PLOTCORR,PLOTFIG)
                
                
% [idPS pmax smax] = findSP_t(T1,D1,T2,D2,p1,s1,p2,s2,dt,N,...
%                   winstart,int_factor,interp_style,PLOTCORR,PLOTFIG)
%
% findSP_t is used to dfind the differential SP time between two events from
% the same cluster.


% Modified on FEB-25-2010
%       detrend sd1 and sd2 before cross-corelating.
                

if nargin == 13
    PLOTFIG = 0;
    PLOTCORR = 0;
elseif nargin == 14;
    PLOTCORR = 0;
end

                
                
%% Make sure D1 and D2 are column-vectors

[nr1 nc1] = size(D1);
[nr2 nc2] = size(D2);

if nc1 ~= 1, D1 = D1'; end
if nc2 ~= 1, D2 = D2'; end

clear nr1 nc1 nr2 nc2

%%
    
                               
% P-wave
pd1 = detrend(D1(p1-winstart:p1+N-winstart-1));
pd2 = detrend(D2(p2-winstart:p2+N-winstart-1));

p_ncoeff = sqrt(pd1'*pd1) * sqrt(pd2'*pd2);

[pcorr,lag] = xcorr(pd1,pd2);
npcorr = pcorr/p_ncoeff;


% S-wave
sd1 = detrend(D1(s1-winstart:s1+N-winstart-1));
sd2 = detrend(D2(s2-winstart:s2+N-winstart-1));

s_ncoeff = sqrt(sd1'*sd1) * sqrt(sd2'*sd2);

scorr = xcorr(sd1,sd2);
nscorr = scorr/s_ncoeff;

%% Interpolating the correlation

T = (1:length(pd1));
int_lag = lag(1):1/int_factor:lag(end);

if strcmp(interp_style,'spline') == 1
    int_us = spline(lag,nscorr,int_lag);
    int_up = spline(lag,npcorr,int_lag);
    
elseif strcmp(interp_style,'sinc') == 1
%     int_us = sinc_interp(lag*dt,npcorr',int_lag*dt);
%     int_up = sinc_interp(lag*dt,nscorr',int_lag*dt);
    int_us = interpft(nscorr,length(int_lag));
    int_up = interpft(npcorr,length(int_lag));   
    
else
    error('Interpolation must be defined as ''sinc'' or ''spline''.')
end


idPS = (int_lag(abs(int_us) == max(abs(int_us))) ...
            - int_lag(abs(int_up) == max(abs(int_up))))*dt;
        
pmax = int_up(abs(int_up) == max(abs(int_up)));
smax = int_us(abs(int_us) == max(abs(int_us)));
        
%% Plot results

if PLOTCORR == 1;

figure
subplot(121)
plot(lag*dt,abs(npcorr),'.',int_lag*dt,abs(int_up),'b-')
subplot(122)
plot(lag*dt,abs(nscorr),'.',int_lag*dt,abs(int_us),'b-')

end




if PLOTFIG == 1
    Pfig = figure; clf
        Pfigtitle = sprintf('P and S Waves XCorr Estimates');
        set(Pfig,'Name',Pfigtitle, ...
                 'NumberTitle','on')
%         set(Pfig,'Position',[1441 1651 1600 1127])  % SECONDARY SCREEN
        set(Pfig,'Position',[1 25 1440 759])      % MAIN SCREEN

    % set(Pfig,'Position',[49 -21 1392 805])

    % Initial Seismograms + Boxes
    % Event 1
    subplot(5,4,[1:4])
    plot(T1,D1)
    title(sprintf('Signal 1 (in seconds)'))
    ylabel('DU')
    % xlabel('Time (min)')
    hold on
    plot( ... P-wave box
         [T1(p1-winstart) T1(p1-winstart)],[min(sd1)*1.33 max(sd1)*1.33],'k--', ...
         [T1(p1+N-winstart-1) T1(p1+N-winstart-1)],[min(sd1)*1.33 max(sd1)*1.33],'k--', ...
         [T1(p1-winstart) T1(p1+N-winstart-1)],[min(sd1)*1.33 min(sd1)*1.33],'k--', ...
         [T1(p1-winstart) T1(p1+N-winstart-1)],[max(sd1)*1.33 max(sd1)*1.33],'k--', ...
         ... S-wave box
         [T1(s1-winstart) T1(s1-winstart)],[min(sd1)*1.33 max(sd1)*1.33],'k--', ...
         [T1(s1+N-winstart-1) T1(s1+N-winstart-1)],[min(sd1)*1.33 max(sd1)*1.33],'k--', ...
         [T1(s1-winstart) T1(s1+N-winstart-1)],[min(sd1)*1.33 min(sd1)*1.33],'k--', ...
         [T1(s1-winstart) T1(s1+N-winstart-1)],[max(sd1)*1.33 max(sd1)*1.33],'k--')
    xlim([T1(p1)-1*60 T1(p1-75)+8*60])
    ptext1 = text(T1(p1-winstart),max(sd1)*1.20,'P-wave');
    ptext2 = text(T1(s1-winstart),max(sd1)*1.20,'S-wave');
    ylim([-5*mean(abs(sd1)) 5*mean(abs(sd1))])

    % Event 2
    subplot(5,4,[5:8])
    plot(T2,D2)
    title(sprintf('Signal 2 (in seconds)'))
    ylabel('DU')

    hold on
    plot( ... P-wave box
         [T2(p2-winstart) T2(p2-winstart)],[min(sd2)*1.33 max(sd2)*1.33],'k--', ...
         [T2(p2+N-winstart-1) T2(p2+N-winstart-1)],[min(sd2)*1.33 max(sd2)*1.33],'k--', ...
         [T2(p2-winstart) T2(p2+N-winstart-1)],[min(sd2)*1.33 min(sd2)*1.33],'k--', ...
         [T2(p2-winstart) T2(p2+N-winstart-1)],[max(sd2)*1.33 max(sd2)*1.33],'k--', ...
         ... S-wave box
         [T2(s2-winstart) T2(s2-winstart)],[min(sd2)*1.33 max(sd2)*1.33],'k--', ...
         [T2(s2+N-winstart-1) T2(s2+N-winstart-1)],[min(sd2)*1.33 max(sd2)*1.33],'k--', ...
         [T2(s2-winstart) T2(s2+N-winstart-1)],[min(sd2)*1.33 min(sd2)*1.33],'k--', ...
         [T2(s2-winstart) T2(s2+N-winstart-1)],[max(sd2)*1.33 max(sd2)*1.33],'k--')
    xlim([T2(p2)-1*60 T2(p2-75)+8*60])
    ptext2 = text(T2(p2-winstart),max(sd2)*1.20,'P-wave');
    stext2 = text(T2(s2-winstart),max(sd2)*1.20,'S-wave');
    ylim([-5*mean(abs(sd2)) 5*mean(abs(sd2))])    


    set(ptext1,'Color', [0 0 0])
    set(ptext2,'Color', [0 0 0])
    % ----------------------

    % Cross-Correlation
    subplot(5,4,[9 10 13 14 17 18]);
    plot(lag*dt,abs(npcorr),'b',int_lag*dt,abs(int_up),'b-')%,lag,up,'b.',lag,us,'r.')
    hold on
    plot([int_lag(abs(int_up) == max(abs(int_up))) int_lag(abs(int_up) == max(abs(int_up)))]*dt,...
        [0 1],'b--')
    plot([int_lag(abs(int_us) == max(abs(int_us))) int_lag(abs(int_us) == max(abs(int_us)))]*dt,...
        [0 1],'r--')
    xlim([min(lag*dt) max(lag*dt)])
    legend('P')
    ylabel('Correlation Coefficient')
    xlabel('Lag (s)')
    title('Cross-Correlation (P-waves)')
    
   
    
    
    %%
    
    text((min(lag)+6)*dt,.95,sprintf('d(S-P) = %.4f s',idPS))
    if strcmp(interp_style,'sinc') == 1
            text((min(lag)+6)*dt,.85,'SINC Interp')
    elseif strcmp(interp_style,'spline') == 1
           text((min(lag)+6)*dt,.85,'SPLINE Interp')
    end

    % Maximum + dPS
    subplot(5,4,[11 12 15 16 19 20])

    plot(lag*dt,abs(nscorr),'r',int_lag*dt,abs(int_us),'r-')%,lag,up,'b.',lag,us,'r.')
    hold on
    plot([int_lag(abs(int_up) == max(abs(int_up))) int_lag(abs(int_up) == max(abs(int_up)))]*dt,...
        [0 1],'b--')
    plot([int_lag(abs(int_us) == max(abs(int_us))) int_lag(abs(int_us) == max(abs(int_us)))]*dt,...
        [0 1],'r--')
    xlim([min(lag*dt) max(lag*dt)])
    legend('S')
    ylabel('Correlation Coefficient')
    xlabel('Lag (s)')
    title('Cross-Correlation (S-waves)')


%     if BANDPASS == 0
%         xlabel('Lag (s)')
%     elseif BANDPASS == 1
%         xlabel(sprintf('Lag (s)\nSignal has been filtered'))


%     end
    
end

 %% TEMP for comps proposal
    figure(97)
    subplot(6,4,4*(ii-1)+3)
    plot(int_lag*dt,abs(int_up),'b-')%,lag,up,'b.',lag,us,'r.')
    hold on
    plot([int_lag(abs(int_up) == max(abs(int_up))) int_lag(abs(int_up) == max(abs(int_up)))]*dt,...
        [0 1],'b--')
    plot([int_lag(abs(int_us) == max(abs(int_us))) int_lag(abs(int_us) == max(abs(int_us)))]*dt,...
        [0 1],'r--')
%     text((min(lag)+6)*dt,.95,sprintf('d(S-P) = %.4f s',idPS))
%     xlim([min(lag*dt) max(lag*dt)])
    xlim([-3 3])
    set(gca,'XTick',[],'YTick',[])
%     legend('P')
%     ylabel('Correlation Coefficient')
%     xlabel('Lag (s)')
%     title('Cross-Correlation (P-waves)')
    
    
    subplot(6,4,4*(ii-1)+4)
    plot(int_lag*dt,abs(int_us),'r-')%,lag,up,'b.',lag,us,'r.')
    hold on
    set(gca,'XTick',[],'Ytick',[])
    
    plot([int_lag(abs(int_up) == max(abs(int_up))) int_lag(abs(int_up) == max(abs(int_up)))]*dt,...
        [0 1],'b--')
    plot([int_lag(abs(int_us) == max(abs(int_us))) int_lag(abs(int_us) == max(abs(int_us)))]*dt,...
        [0 1],'r--')
    xlim([-3 3])
%     xlim([min(lag*dt) max(lag*dt)])
%     legend('S')
%     ylabel('Correlation Coefficient')
%     xlabel('Lag (s)')
%     title('Cross-Correlation (S-waves)')







