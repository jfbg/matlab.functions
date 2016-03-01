function out = medianNAN(in)

% medianNAN(in) outputs the median of a vector even if there are some NaN
% values in it.

[nr nc] = size(in);

if nr > 1 && nc > 1
    error('The input must be a vector')
end

in(isnan(in) == 1) = [];

out = median(in);