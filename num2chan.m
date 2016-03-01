function channel = num2chan(in)

if in == 1, channel = 'lpx';
elseif in == 2, channel = 'lpy';
elseif in == 3, channel = 'lpz';
elseif in == 4, channel = 'spz';
elseif in == 5, channel = 'lph';
else
    error('Type must be 1 (lpx), 2 (lpy), 3 (lpz), 4 (spz) or 5 (lph)');
end

return