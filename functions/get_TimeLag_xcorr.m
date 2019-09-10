function [lag, coeff_func, lag_func] = get_TimeLag_xcorr_jeelab( x, y, maxlag )
% Usage: lag = get_TimeLag_xcorr_jeelab(x, y, maxlag)
% 
% Calculating time-lag between two time-series signal x, and y
% 
% -- input form --
% x, y: (Filtered) EEG signal (1-D vector)
% maxlag: Maximum time lag to consider (default: half signal length)
% 
% 2019-09-10
% 
if nargin < 3, maxlag = round(length(x)/2); end
[coeff_func, lag_func] = xcorr( x, y, maxlag, 'coeff' );
[~,lag]= max(coeff_func);
end
