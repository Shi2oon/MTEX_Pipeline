function [fitresult, gof] = createFit(x, y)
%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( x, y );

% Set up fittype and options.
ft = fittype( 'K/sqrt(x+b)+c', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [mean(x(10)) 0 mean(y)];
opts.Lower = [0 -mean(y) -inf];
opts.Upper = [inf 0 inf];
% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts);

