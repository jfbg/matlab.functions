
function [Stack] = makeStack(list,cluster,station,channel,DESPIKE)

% [Stack] = makeStack(list,cluster,station,channel,DESPIKE,ROTATE,SIG) is used to
%     build stacks, normally used by the findSP function. It outputs the stack as 
%     a .mat file, and a png of the stack.
% 
% list        list of events in a column vector.
%             e.g. list = [19752501447;
%                     19752750645;
%                     19752781412;
%                     19753292320;
%                     19761050216];
% cluster     source region number
% station     12, 14, 15 or 16
% channel     'lpx', 'lpy', 'lpz', 'spz', 'R', 'SH' or 'SV'
%                                 (radial, shear-horizontal, shear-vertical)
% DESPIKE     1 = used despiked data, 0 = use orignal data
%                    Only available for a limited amount of data.

% Last modified: 2010-JAN-29
%   JF   Modified the codes so that it stacks for R, SH, and SV channels.
%       


%%% Testing
% % % 
% % % station = 16;
% % % channel = 'lpy';
% % % 
% % % list = [19752501447;
% % %         19752750645;
% % %         19752781412;
% % %         19753292320;
% % %         19761050216;
% % %         19761290826;
% % %         19761322226;
% % %         19762111933;
% % %         19762391244;
% % %         19761290826;
% % %         19761322226;
% % %         19761840908;
% % %         19762111933;
% % %         19762390908;
% % %         19762391244;
% % %         19762681627];

if nargin == 4
    DESPIKE = 0;
end

if DESPIKE == 1;
    dp = 'd';
else
    dp = '';
end
% % %     
%%

load GFS_folder.mat
tmax = 25*60; %length of signal kept after time(0)

if strcmp(channel,'spz') == 1
    dt = 0.018828000000099;
else
    dt = 0.150937507688746;
end

%% Check which files are available and get rid of the ones we don't have in the list
[SIGS figid] = plotSIGS(list);
close(figid)
load StatChan.mat
col = 4*find(stations == station)-4+find(strcmp(channels,channel));
list(SIGS(:,col) == 0) = [];

[nr nc] = size(list);


%% Getting and Naming the different files
figure(2),clf,close 2
figure(1),clf,close 1

for l = 1:nr

    varT = sprintf('T%03.0f',l);
    varD = sprintf('D%03.0f',l);
    
    if strcmp(channel,'lpx') == 1 || strcmp(channel,'lpy') == 1 ...
            || strcmp(channel,'lpz') == 1 || strcmp(channel,'spz') == 1

        if DESPIKE == 1
            eval(['[' varT ' ' varD '] = getGFS(list(l),station,channel,1);'])
        else
            eval(['[' varT ' ' varD '] = getGFS(list(l),station,channel);'])
        end
        
    elseif strcmp(channel,'R') == 1 || strcmp(channel,'SH') == 1 ...
            || strcmp(channel,'SV') == 1
        
        [rott R SH SV] = rotateSIGS(list(l),station,DESPIKE,cluster,0);
        
        eval([varT '=rott;'])
        eval([varD '=' channel ';'])
        
    end

    
    figure(1)
    set(gcf,'Position',[79 838 1221 542])
    clf
    
    %Plot the signal and pick time(0)
    eval(['plot(' varT '/60,' varD ')'])
    hold on
    eval(['plot([tmax/60 tmax/60],[min(' varD ') max(' varD ')],''r--'')'])
    
    eval(['maxD = max(abs(' varD '));'])

    plottitle = sprintf('%s%s %.0f / %.0f',channel,dp,l,nr);
    title(plottitle);
    
    if maxD > 25
        ylim([-20 20])
    end
    
%     pause
    
    [t0(l) y] = ginput(1);
    
    close(1)
    
    %% Windowing signals
    eval([varD '=' varD '(find(' varT ' > t0(l)*60,1):find(' varT ' > (t0(l)*60 + tmax)));'])
    eval([varT '=' varT '(find(' varT ' > t0(l)*60,1):find(' varT ' > (t0(l)*60 + tmax)));'])

%     figure(2)
%     subplot(length(list),1,l)
%     eval(['plot(' varT ',' varD ')'])

end

%% Get rids of errors and make all signals the same length

figure(3), clf, close(3)

for l = 1:nr
    varD = sprintf('D%03.0f',l);

    eval(['sigsize(l) = length(' varD ');'])
    
end

newlength = min(sigsize(sigsize ~= 0));
    
    
for l = 1:nr
    varD = sprintf('D%03.0f',l);
    
    eval([varD '(newlength+1:end)=[];'])
    
end

%% Cross-correlate + stack
    
eval(sprintf('Stack = D%03.0f;',find(sigsize ~= 0,1)))

n = newlength;

% lag = -n+1:n-1;

sgn = NaN(nr,1);

for l = 1:nr
    varD = sprintf('D%03.0f',l);

    
    if sigsize(l) == 0
        continue
    else
        eval(['[K,lag] = xcorr(Stack,' varD ');'])
        maxc = lag(abs(K) == max(abs(K)));
        sgn(l) = sign(K(abs(K) == max(abs(K))));    

        if maxc < 0
            eval([varD '(1:abs(maxc)) = [];'])
            eval([varD '(end:end+abs(maxc)) = 0;'])
        elseif maxc > 0
            eval([varD '(maxc+1:end) = ' varD '(1:end-maxc);'])
            eval([varD '(1:maxc) = 0;'])
        else
        end

        if sgn(l) == -1
            eval(['Stack = Stack + -1*' varD ';'])
        elseif sgn(l) == 1
            eval(['Stack = Stack +' varD ';'])
        elseif sgn(l) == 0
            error('SGN is 0')
        end
    end
        
        
end

tempStack = Stack;
clear Stack



%% Cross-correlation with temp stack
% Cross-correlate all signals selected with temporary stack and get the
% max correlation coefficient, use it as a weight for the final stack.

innerS = tempStack'*tempStack;
maxcoeff = NaN(size(sigsize));
for l = 1:nr
    varD = sprintf('D%03.0f',l);

    
    if sigsize(l) == 0
        continue
    else
         eval(['ncoeff = sqrt(' varD '''*' varD ') * sqrt(innerS);']);
         eval(['[ncorr,lag] = xcorr(tempStack,' varD ');'])
         ncorr = ncorr/ncoeff;
         maxcoeff(l) = max(abs(ncorr));

    end
end

Stack = zeros(size(tempStack));

for l = 1:nr
    varD = sprintf('D%03.0f',l);
    
     if sigsize(l) == 0
        continue
     else
         eval(['Stack = Stack + ' varD '*sgn(l) * maxcoeff(l)^2;'])
     end
end

%% Select ToAp and end of Stack then window stack
figure(4)
clf
subplot(211)
plot(abs(Stack).^2)
subplot(212)
plot(Stack,'r')
title('THIS IS THE STACK!!! --> Select ToAp and END OF STACK')
set(gcf,'Position',[79 168 1346 796])
scale_subplots(1.2)
pause

[x y] = ginput(2);

p = floor(x(1));
tend = floor(x(2))-floor(p);

allStack = Stack;
Stack(1:p) = [];
Stack(tend:end) = [];

close 4

figure(5)
clf
set(gcf,'Position',[79 838 1221 542])

subplot(211)
plot(abs(Stack).^2)
subplot(212)
plot(Stack,'k')
title('Select dT')
set(gcf,'Position',[79 168 1346 796])
scale_subplots(1.2)

[dT y] = ginput(1);
dT = floor(dT);

close 5

%%
if DESPIKE == 1;
    dp = 'd';
else
    dp = '';
end


filename = sprintf('A%03.0f_%2.0f_%s%s_STACK.events',cluster,station,channel',dp);


fid = fopen(filename,'w');
fprintf('\n\nEvents used for stack and max corr coeff with Temp Stack:\n\n');
fprintf(fid,'%% Events used for %03.0f_%2.0f_%s%s stack:\n',cluster,station,channel,dp);
fprintf(fid,'(with max corr coefficient with temp stack)\n\n');
fprintf(fid,'Total number of events used:  %.0f\n',length(list(sigsize ~=0)));
fprintf(fid,'Sampling interval between P and S arrivals: %.0f\n\n',dT);

for l = 1:nr
        if sigsize(l) == 0
            continue
        else
            fprintf('%11.0f         %0.3f\n',list(l),maxcoeff(l));
            fprintf(fid,'%11.0f         %0.3f\n',list(l),maxcoeff(l));
        end
end

fprintf('dT = %.0f\n',dT);
fprintf('Saved in %s\n',filename);


filename2 = sprintf('A%03.0f_%2.0f_%s%s',cluster,station,channel,dp);

eval([filename2 '=Stack;'])
eval([[filename2 '_all'] '= allStack;'])

eval(['save ' filename2 '.mat ' filename2 ' ' [filename2 '_all'] ' dT'])


% close 1 2 3 4 5

% eval(['dt = ' varT '(2) - ' varT '(1);'])

figure(6)
clf
plot(((1:length(allStack))-p)*dt/60,allStack)
hold on
plot([0 0]*dt/60,[min(allStack) max(allStack)],'r--')
plot([dT dT]*dt/60,[min(allStack) max(allStack)],'r--')
xlim([1-p length(allStack)-p]*dt/60)
ylim([min(allStack) max(allStack)])
set(gcf,'Position',[197 498 1179 423])
set(gcf,'PaperPosition',[0.25 2.5 11 6])
title(sprintf('Stack of A%03.0f-%2.0f-%s%s',cluster,station,channel,dp))
xlabel('Time (min)')



saveas(gcf, [filename2 '_fig.fig'],'fig')
saveas(gcf, [filename2 '_fig.png'],'png')

fclose(fid)


return




















    
    
    
    
    

