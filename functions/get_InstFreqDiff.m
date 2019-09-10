function [ifd, h_x, h_y, ang_diff] = get_InstFreqDiff_jeelab( x, y, srate )
% Usage: ifd = get_InstFreqDiff_jeelab(x, y, srate)
% 
% Calculating instantaneous frequency differnece (IFD) from filtered
% time-series signal x and y
% 
% -- input form --
% x, y: Filtered EEG signal (1-D vector)
% srate: Sampling rate
% 
% 2019-09-10.
% 
h_x = angle(hilbert(x)); % hilbert angle of signal x
h_y = angle(hilbert(y)); % hilbert angle of signal y
ang_diff = h_x - h_y; % angle difference
freqF = srate/(2*pi); % frequency factor
ifd = freqF * diff( unwrap(ang_diff)); % instantaneous frequency difference
end