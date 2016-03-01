% [T D] = getGFS(eventtime,station,channel,despike,TRANGE,folder,verbose)
%
%
% Inputs:   eventtime = filename for the event
%           station (12, 14, 15 or 16)
%           channel (lpx, lpy, lpz or spz)
%           TRANGE is time range requested (eg [0 20]) in minutes
%           depsike = 0 or 1 (some date is despiked). 0 is default.
%           verbose, set to 0 to keep script quiet
%           folder is string (use if data is not stored in default folder)
%               Default: See ./GFS_folder.mat
%
% Outputs:  T is time vector IN SECONDS
%           D is ground motion vector (in DU)
%
% Note: All Z-channel data has been multiplied by -1 to follow the
% convention that the positive z-axis points downward. The positive z-axis
% in the original data was pointing up.


function [T D] = getGFS(eventtime,station,channel,despike,TRANGE,folder)




% Change the folder path if it is not the default one
if nargin < 6
    load GFS_folder.mat
    %Check if Pinot is mounted
%     if exist('/Volumes/Pinot','file') == 0
%         error('Please mount the Pinot volume')
%     end
end


% Change the file extension if despiked data is requested
if nargin >= 4
    if despike == 1
        filename = sprintf('out_%11.0f_%2.0f_%s.mat',eventtime,station,[channel 'd']);
        if exist([[folder 'DESPIKED/'] filename],'file') == 2
        channel = [channel 'd'];
        folder = [folder 'DESPIKED/'];
        end
    end
end

filename = sprintf('out_%11.0f_%2.0f_%s.mat',eventtime,station,channel);

% makre sure the file exists
if exist([folder filename],'file') ~= 2
    beep
    fprintf('%s\n',[folder filename])
    fprintf('\nThe file does not exist in the specified directory.\nMake sure it was converted to ASCII from the GFS format.\n\n')

    T = NaN;
    D = NaN;

else

    load([folder filename]);
    
  
%     fprintf('Loading %s%s\n',folder,filename);
  

    T = T*60;
    
    
    % Reverse z-axis to follow convention (z is positive downward)
    if strcmp(channel,'lpz') == 1 || strcmp(channel,'spz') == 1
      D = -D;
    end
    

    if nargin >= 5
      Tind1 = find(T>=TRANGE(1)*60,1);
      Tind2 = find(T>=TRANGE(2)*60,1);
      
      if isempty(Tind2) == 1, Tind2 = length(T); end
      
        D = D(Tind1:Tind2);
        T = T(Tind1:Tind2);
    end
end


