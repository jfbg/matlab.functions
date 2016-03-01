function OUT = rms(IN)

if size(IN,1) == 1 || size(IN,2) == 1

OUT = (mean((IN(:).^2))).^.5;

else
  
  OUT = nan(1,size(IN,2));
  
  for i = 1:size(IN,2);
    OUT(i) = (mean((IN(:,i).^2))).^.5;
  end
  
end

return