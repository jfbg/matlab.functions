function [SIGS figid] = plotSIGS(list,despike)

% [SIGS figid] = plotSIGS(list,despike)
% 
% plotSIGS reads a list of event and shows fore which ones there is a file available.
% 
% despike is 1 (look for depsiked FILT1 events) or 0 (use FILT1 events)
% SIGS is a matrix showing which file is available
% figid is the figure  handle (so one can close it)


load GFS_folder.mat

if nargin == 1
    despike = 0;
end

SIGS = zeros(length(list),16);

stations = [12 14 15 16];

if despike == 1
    channels = {'lpxd' 'lpyd' 'lpzd' 'spzd'};
    folder = [folder 'DESPIKED/'];
elseif despike == 0
    channels = {'lpx' 'lpy' 'lpz' 'spz'};
end

for e = 1:length(list)
    
    for s = 1:length(stations)
        
        for c = 1:length(channels)
            
            filename = sprintf('out_%11.0f_%2.0f_%s.mat',list(e),stations(s),channels{c});
            if exist([folder filename],'file') == 2
                SIGS(e,4*s-4+c) = 1;
            end
        end
    end
end


%% 

if despike == 1
xticks = {'12lpxd' '12lpyd' '12lpzd' '12spzd' '14lpxd' '14lpyd' '14lpzd' '14spzd'...
            '15lpxd' '15lpyd' '15lpzd' '15spzd' '16lpxd' '16lpyd' '16lpzd' '16spzd'}; 
else
xticks = {'12lpx' '12lpy' '12lpz' '12spz' '14lpx' '14lpy' '14lpz' '14spz'...
            '15lpx' '15lpy' '15lpz' '15spz' '16lpx' '16lpy' '16lpz' '16spz'};
end          
          
figid = figure;
imagesc(SIGS)
caxis([0 1])
colormap([1 1 1; 0.5 0.5 0.5])
grid on
% colorbar
set(gca,'XTick',1:16,'YTick',1:length(list),'Yticklabel',num2str(list),'Xticklabel',xticks)

ylabel('Events')
xlabel('Channels')
title('Signal files availability (Gray = Yes, White = NO)')

set(gcf,'Position',[38 789 1237 616])