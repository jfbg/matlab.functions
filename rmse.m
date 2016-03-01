function out = rmse(in)

% out = rmse(in)
%
% Calculate root mean squared error based on:
%
% sqrt(mean((y - yhat).^2)) 
%
%
% created on July 11


out = sqrt(mean((in-mean(in)).^2));