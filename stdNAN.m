
function out = stdNAN(in)

% meanNAN(in) outputs the mean of a vector even if there are some NaN
% values in it.

[nr,nc] = size(in);

if nr > 1 && nc > 1
    out = nan(1,nc);
    for ii = 1:nc
        temp = in(:,ii);
        temp(isnan(temp) == 1) = [];
        out(ii) = std(temp);
    end
else
    in(isnan(in) == 1) = [];
    out = std(in);
end

