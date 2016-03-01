% Attempt at non-linear least-square fit


function [estimates, model] = fitexpdecay_minval(xdata, ydata)

% Call fminsearch with a random starting point.
start_point = rand(1,3);
model = @expfun;
options.MaxFunEvals = 50000;
options.MaxIter = 500000;
estimates = fminsearch(model, start_point,options);

% expfun accepts curve parameters as inputs, and outputs sse,
% the sum of squares error for A*exp(-lambda*xdata)-ydata,
% and the FittedCurve. FMINSEARCH only needs sse, but we want
% to plot the FittedCurve at the end.
    function [sse, FittedCurve] = expfun(params)
        A = params(1);
        lambda = params(2);
        C = params(3);
        FittedCurve = A .* exp(-xdata/lambda) + C;
        ErrorVector = FittedCurve - ydata;
        sse = sum(ErrorVector .^ 2);
    end
end
