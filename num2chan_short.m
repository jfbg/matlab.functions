function channel = num2chan_short(in)

if in == 1, channel = 'x';
elseif in == 2, channel = 'y';
elseif in == 3, channel = 'z';
elseif in == 4, channel = 'spz';
else
    error('Type must be 1, 2, 3 or 4');
end

return