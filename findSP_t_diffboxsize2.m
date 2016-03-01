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
    
    figure(100)
    % Initial Seismograms + Boxes
    % Event 1
    subplot(2,4,[1:4])
    plot(T1,D1)
    title(sprintf('Signal 1 (in seconds)'))
    ylabel('DU')
    % xlabel('Time (min)')
    hold on
    plot( ... P-wave box
         [T1(p1-winstart) T1(p1-winstart)],[-10 10],'k--', ...
         [T1(p1+N-winstart-1) T1(p1+N-winstart-1)],[-10 10],'k--', ...
         [T1(p1-winstart) T1(p1+N-winstart-1)],[-10 -10],'k--', ...
         [T1(p1-winstart) T1(p1+N-winstart-1)],[10 10],'k--', ...
         ... S-wave box
         [T1(s1-winstart) T1(s1-winstart)],[-10 10],'k--', ...
         [T1(s1+N-winstart-1) T1(s1+N-winstart-1)],[-10 10],'k--', ...
         [T1(s1-winstart) T1(s1+N-winstart-1)],[-10 -10],'k--', ...
         [T1(s1-winstart) T1(s1+N-winstart-1)],[10 10],'k--')
    xlim([T1(p1)-1*60 T1(p1-75)+8*60])
%     ptext1 = text(T1(p1-winstart),max(sd1)*1.20,'P-wave');
%     ptext2 = text(T1(s1-winstart),max(sd1)*1.20,'S-wave');
    ylim([-5*mean(abs(sd1)) 5*mean(abs(sd1))])

    % Event 2
    subplot(2,4,[5:8])
    plot(T2,D2)
    title(sprintf('Signal 2 (in seconds)'))
    ylabel('DU')

    hold on
    plot( ... P-wave box
         [T2(p2-winstart) T2(p2-winstart)],[-8 8],'k--', ...
         [T2(p2+N-winstart-1) T2(p2+N-winstart-1)],[-8 8],'k--', ...
         [T2(p2-winstart) T2(p2+N-winstart-1)],[-8 -8],'k--', ...
         [T2(p2-winstart) T2(p2+N-winstart-1)],[8 8],'k--', ...
         ... S-wave box
         [T2(s2-winstart) T2(s2-winstart)],[-8 8],'k--', ...
         [T2(s2+N-winstart-1) T2(s2+N-winstart-1)],[-8 8],'k--', ...
         [T2(s2-winstart) T2(s2+N-winstart-1)],[-8 -8],'k--', ...
         [T2(s2-winstart) T2(s2+N-winstart-1)],[8 8],'k--')
    xlim([T2(p2)-1*60 T2(p2-75)+8*60])
%     ptext2 = text(T2(p2-winstart),max(sd2)*1.20,'P-wave');
%     stext2 = text(T2(s2-winstart),max(sd2)*1.20,'S-wave');
    ylim([-5*mean(abs(sd2)) 5*mean(abs(sd2))])    


%     set(ptext1,'Color', [0 0 0])
%     set(ptext2,'Color', [0 0 0])
    % ----------------------

end






