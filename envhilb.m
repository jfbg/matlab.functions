
function OUT = envhilb(IN)

% OUT = envhilb(IN)
%
% Envelope of signal using:
%
%   OUT = (imag(hilbert(IN)).^2 + IN.^2).^.5;

OUT = (imag(hilbert(IN)).^2 + IN.^2).^.5;

return