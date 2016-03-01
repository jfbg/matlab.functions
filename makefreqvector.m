function w = makefreqvector(len,T,dt)

% w = makefreqvector(len,T,dt)
% 
% len is length of signal (number of elements)
% T is duration of signal
% dt is sampling frequency

if mod(len,2) == 0
  
  w1 = (1:len/2) * 1/T;
  w = [fliplr(w1(1:end))*-1 0 w1(1:end-1)];
  
elseif mod(len,2) == 1
  
  w1 = (1:(len-1)/2) * 1/T;
  w = [fliplr(w1(1:end))*-1 0 w1(1:end)];
  
end

return