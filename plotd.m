function plotd(d,dist,t)

% function plotd(d,dist,t)

figure

for ii= 1:length(dist)
    
    plot(t,d(:,ii))
    title(num2str(dist(ii)))
    
    pause
end
    