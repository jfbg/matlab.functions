function out = doy(in)

% YYYYDDD = doy(YYYYMMDD)
%
% Convert YYMMDD into a YYYYDDD format.

%%

% in = 20000123;

out = nan(size(in));

for i = 1:length(in)

year = floor(in(i)/10000);
t = in(i)-year*10000;
month = floor(t/100);
day = t-month*100;


M = [1 31;
     2 28;
     3 31;
     4 30;
     5 31;
     6 30;
     7 31;
     8 31;
     9 30;
     10 31;
     11 30;
     12 31];
 
if mod(year,4) == 0;
    M(2,2) = 29;
end

newday = sum(M(1:find(month == M(:,1))-1,2)) + day;

out(i) = year*1000+newday;

end

return