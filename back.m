function back

% back
%
% After FCT, back.m change the current directory back to its initial value.

load /Users/JFBG/src/MatLab/Functions/currentdir.mat
fprintf('%s\n',currentdir)
eval(['cd ' currentdir])