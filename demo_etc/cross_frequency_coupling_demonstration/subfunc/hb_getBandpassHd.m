function [highpassHd, lowpassHd] = hb_getBandpassHd(freqBand, filterOrder, Fs)
% function [highpassHd, lowpassHd] = hb_getBandpassHd(freqBand, filterOrder, Fs)


if nargin < 2
    filterOrder    = 8;     % Order
    Fs   = 2000;  % Sampling Frequency
end


h_high = fdesign.highpass('n,f3db', filterOrder, freqBand(1), Fs);
h_low = fdesign.lowpass('n,f3db', filterOrder, freqBand(2), Fs);

highpassHd = design(h_high, 'butter','SystemObject', true);
lowpassHd = design(h_low, 'butter','SystemObject', true);


return


