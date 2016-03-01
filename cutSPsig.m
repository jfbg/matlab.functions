function [dout tout] = cutSPsig(d,t,cutSP)

if cutSP < length(d)
    dout = d(1:cutSP,:);
    tout = t(1:cutSP);
else
    dout = d;
    tout = t;
end

end