function k = plotall(list,despike,stations,TYPE,NO_S)

% k = plotall(list,despike,stations,TYPE,NO_S)
% Filename:     plotall.m
% DateCreated:  2008W
% LastModified: 2010/04/06
% Author:       JFBG
% Description:  Plot all signal from same event in one figure             
% Input(s):     list is vector containing event times
%               despike is 0 or 1. If no despiked traces exits, it will
%                   load the regular one
%               stations is vector of desired stations (leave empty if all
%                   stations are required)
%               TYPE is 'TIME' if data plotted versus time, or 'INDEX' if
%                   only data is plotted (versus index).
%               NO_S is set to 1 of one doesn't want to spz channel to be
%                   plotted.
% Output(s):    Plots of signal amplitude vs time for all stations of each
%               listed event.
%               k is 0 if not events exist for that selection of stations

% Other:        





%% Convert Integers to strings


load GFS_folder

if nargin == 1
    despike = 0;
    load StatChan
    TYPE = 'TIME';
    NO_S = 0;
end

if nargin == 2
  load StatChan
  TYPE = 'TIME';
  NO_S = 0;
end

if nargin == 3
  TYPE = 'TIME';
  NO_S = 0;
end

if nargin == 4
  NO_S = 0;
end

if despike == 0
    filedir = folder;
    dp = '';
elseif despike == 1
    filedir = [folder 'DESPIKED/'];
    dp = 'd';
end

%% Load the available data files
% 
for e = 1:length(list)
    for j = 1:length(stations)
        
       
        clear m1 m2 m3 m4

        filename = sprintf('out_%11.0f_%2.0f',list(e),stations(j));

        
        if exist([filedir filename '_lpx' dp '.mat'],'file') == 2;
            load([filedir filename '_lpx' dp '.mat']);
            m1 = [T D];
        elseif exist([folder filename '_lpx.mat'],'file') == 2;
            load([folder filename '_lpx.mat']);
            m1 = [T D];
        else
        end

        if exist([filedir filename '_lpy' dp '.mat'],'file') == 2;
            load([filedir filename '_lpy' dp '.mat']);
            m2 = [T D];
        elseif exist([folder filename '_lpy.mat'],'file') == 2;
            load([folder filename '_lpy.mat']);
            m2= [T D];
        else
        end

        if exist([filedir filename '_lpz' dp '.mat'],'file') == 2;
            load([filedir filename '_lpz' dp '.mat']);
            m3 = [T D];
        elseif exist([folder filename '_lpz.mat'],'file') == 2;
            load([folder filename '_lpz.mat']);
            m3 = [T D];
        else
        end
        
        if NO_S == 0
            if exist([filedir filename '_spz' dp '.mat'],'file') == 2;
                load([filedir filename '_spz' dp '.mat']);
                m4 = [T D];
            elseif exist([folder filename '_spz.mat'],'file') == 2;
                load([folder filename '_spz.mat']);
                m4 = [T D];
            else
            end
        end

        k = exist('m1','var') + exist('m2','var') + exist('m3','var') + exist('m4','var');

%         save Ms


% Correct for type of plot

if exist('m1','var') == 1 && strcmp(TYPE,'INDEX') == 1
  m1(:,1) = 1:length(m1(:,1));
end
if exist('m2','var') == 1 && strcmp(TYPE,'INDEX') == 1
  m2(:,1) = 1:length(m2(:,1));
end
if exist('m3','var') == 1 && strcmp(TYPE,'INDEX') == 1
  m3(:,1) = 1:length(m3(:,1));
end
if exist('m4','var') == 1 && strcmp(TYPE,'INDEX') == 1
  m4(:,1) = 1:length(m4(:,1));
end

if strcmp(TYPE,'INDEX') == 1
  timelabel = 'Index';
else timelabel = 'Time (min)';
end


%% Plot the time series on one figure

i=1;
% scrsz = get(0,'ScreenSize');

if k == 0
    continue
else
  
if stations(j) == 12, fig = 1;
elseif stations(j) == 14, fig = 2;
elseif stations(j) == 15, fig = 3;
elseif stations(j) == 16, fig = 4;
end

figure(fig)
clf

% set(gcf,'Position',[1 scrsz(2) scrsz(3) scrsz(4)]);

if exist('m1','var') == 1
    l1=length(m1)/2;
    subplot(k,1,i)
    plot(m1(:,1),m1(:,2));
    hold on
%     zeroT1 = LASAGINPUT(m1);
%     plot(zeroT1(:,1), zeroT1(:,2),'dr')
%     axis([min(m1(:,1)) max(m1(:,1)) -max([abs(min(m1(10:l1,2))) max(m1(10:l1,2))])/5*6 ...
%         max([abs(min(m1(10:l1,2))) max(m1(10:l1,2))])/5*6])
%     ylabel('Amplitude')
    %xlabel('Time (min)')
    title(sprintf('%11.0f - %2.0f LPX (y-axis in DU)',list(e),stations(j)))
    i=i+1;
    clear l1
else
end

if exist('m2','var') == 1
    l2=length(m2)/2;
    subplot(k,1,i)
    plot(m2(:,1),m2(:,2));
    hold on
%     zeroT2 = LASAGINPUT(m2);
%     plot(zeroT2(:,1), zeroT2(:,2),'dr')
%     axis([min(m2(:,1)) max(m2(:,1)) -max([abs(min(m2(10:l2,2))) max(m2(10:l2,2))])/5*6 ...
%         max([abs(min(m2(10:l2,2))) max(m2(10:l2,2))])/5*6])
%     ylabel('Amplitude')
    %xlabel('Time (min)')
    title(sprintf('%2.0f LPY',stations(j)))
    i=i+1;
    clear l2
else
end

if exist('m3','var') == 1
    l3=length(m3)/2;
    subplot(k,1,i)
    plot(m3(:,1),m3(:,2));
    hold on
%     zeroT3 = LASAGINPUT(m3);
%     plot(zeroT3(:,1), zeroT3(:,2),'dr')
%     axis([min(m3(:,1)) max(m3(:,1)) -max([abs(min(m3(10:l3,2))) max(m3(10:l3,2))])/5*6 ...
%         max([abs(min(m3(10:l3,2))) max(m3(10:l3,2))])/5*6])
%     ylabel('Amplitude')
    %xlabel('Time (min)')
    title(sprintf('%2.0f LPZ',stations(j)))
    if exist('m4','var') == 0
      xlabel(timelabel)
    end
    i=i+1;
    %clear l3
else
end

if exist('m4','var') == 1
    l4=length(m4)/2;
    subplot(k,1,i)
    plot(m4(:,1),m4(:,2));
    hold on
%     zeroT4 = LASAsGINPUT(m4);
%     plot(zeroT4(:,1), zeroT4(:,2),'dr')
%     axis([min(m4(:,1)) max(m4(:,1)) -max([abs(min(m4(10:l4,2))) max(m4(10:l4,2))])/5*6 ...
%         max([abs(min(m4(10:l4,2))) max(m4(10:l4,2))])/5*6])
%     ylabel('Amplitude')
    xlabel(timelabel)
    title(sprintf('%2.0f SPZ',stations(j)))
    clear l4
else
end
end
scale_subplots(1.1)
    end
    
  if length(list) > 1, pause, end  
end
