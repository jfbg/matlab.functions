function OUT = rmsNAN(IN)

if size(IN,1) == 1 || size(IN,2) == 1
   
IN(isnan(IN) == 1) = [];

OUT = (mean((IN(:).^2))).^.5;

else
  
  error('Only vectors can be used for rmsNAN');
  
end

return