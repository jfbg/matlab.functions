function phback

% back
%
% After FCT, back.m change the current directory back to its initial value.

load /Users/JF/src/MatLab/Functions/phcurrentdir.mat
fprintf('%s\n',phcurrentdir)
eval(['cd ' phcurrentdir])