function [YYYY MM DD] = doy(in)

% [YYYY MM DD] = doy(YYYYDDD)
%
% Convert YYYYDDD into a YYYY MM DD format.
% Can be a column vector of YYYYDDD

%%

% in = 20000123;

YYYY = floor(in/1000);
MM = nan(size(in));
DD = nan(size(in));
D = in-YYYY*1000;



for i = 1:length(in)
    
    if isnan(in(i))
        continue
    end
    
    if D(i) > 366
        YYYY(i) = NaN;
        continue
    end
    
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
 


if mod(YYYY(i),4) == 0;
    M(2,2) = 29;
end
 
M(:,2) = cumsum(M(:,2));
MM(i) = M(find(D(i) <= M(:,2),1),1);

if MM(i) == 1
  DD(i) = D(i);
else
  DD(i) = D(i)-M(MM(i)-1,2);
end

end

disp([YYYY MM DD])

return