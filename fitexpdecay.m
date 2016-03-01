% Attempt at non-linear least-square fit


function [estimates, model,EXITFLAG] = fitexpdecay(xdata, ydata)



% Call fminsearch with a random starting point.
start_point = rand(1,2);
model = @expfun;
% options.MaxFunEvals = 20000;
% options.MaxIter = 20000;
[estimates,~,EXITFLAG] = fminsearch(model, start_point);%,options);


% expfun accepts curve parameters as inputs, and outputs sse,
% the sum of squares error for A*exp(-lambda*xdata)-ydata,
% and the FittedCurve. FMINSEARCH only needs sse, but we want
% to plot the FittedCurve at the end.
    function [sse] = expfun(params)
        A = params(1);
        lambda = params(2);
        FittedCurve = A .* exp(-xdata/lambda);
        ErrorVector = FittedCurve - ydata;
        sse = sum(ErrorVector .^ 2);
    end
end
