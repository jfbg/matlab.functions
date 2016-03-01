% makeGFSlist creates a text file which can be used by the UNIX program bin2ascii to
% convert GFS data into ascii.
%
% text file must be a list of eventtime, one per row.
%
% Make sure to use the convertASCIItoMAT script afterwards to convert from
% ASCII into the .mat format (takes less space)

function makeGFSlist


[FILENAME, PATHNAME, FILTERINDEX] = ...
       uigetfile({'*.*','All files'},'Pick file containing list of events');


list = load([PATHNAME FILENAME]);

fid = fopen([FILENAME '.gfs'],'w');

for i = 1:size(list,1)
    
    fprintf(fid,'/Volumes/Opus1/LUNAR/FILT_GFS1/%11.0f.gfs/\n',list(i,1));
end
