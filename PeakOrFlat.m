function [pf type] = PeakOrFlat(eventtime,station)

% pf = PeakOrFlat(eventtime,station)
%
%   Check if LP events were recorded in peak or flat mode)
%
% INPUTS:
%   Eventtime is a Mx1 vector with the eventtime ids
%   station is a Mx1 vector for the stations of interest for each Eventime
%
% OUTPUT:
%   pf is a Mx1 of 0 (flat) or 1 (peak)
%   type is string 'flat' or 'peak'.
%   
%
% Based on info in Bulow 2005.
% 
% FLAT from 1975/180 to 1977/086  for s12, s15, s16.
% FLAT from 1974/289 tp 1975/099  for s12 only.
% s14 was always in PEAK mode.

pf = ones(size(eventtime));

% Replafe pfs entries with 0 if mode was FLAT.

for i = 1:length(eventtime)
    
    type{i,1} = 'lppeak';
    
    if station(i) == 12 || station(i) == 15 || station(i) == 16
        if eventtime(i) >= 19751800000 && eventtime(i) <= 19770860000
            pf(i,1) = 0;
            type{i,1} = 'lpflat'; %#ok<*AGROW>
        end
    end
    
    if station(i) == 12
        if eventtime(i) >= 19742890000 && eventtime(i) <= 19750990000
            pf(i,1) = 0;
            type{i,1} = 'lpflat'; 
        end
    end
    
end