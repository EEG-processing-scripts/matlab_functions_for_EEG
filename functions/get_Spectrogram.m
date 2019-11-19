function [spec_d, spec_t, spec_f] = get_Spectrogram( x, t, win_size, t_resolution )
% Usage: [spec_d, spec_t, spec_f] = get_Spectrogram( x, t, win_size, t_resolution )
% 
% Calculating amplitude spectrogram from signal x and time-vector t. 
% 
% -- input form --
% x: Raw EEG signal (1-D vector)
% y: Time vector (in millisecond resolution)
% win_size: Size of sliding moving window (default: 2^10)
% t_resolution: Jump size of sliding moving window (unit: sec, default: 100 msec)
% 
% 2019-09-10
% 

%% Defulat condition
if nargin < 5
    t_resolution = .1;
end; if nargin < 4
    win_size = 2^10;
end

srate = round( 1/nanmean(diff(t)) );
t_fft = [t(1)+(((win_size*.5)+1)/srate), t(end)-(((win_size*.5)+1)/srate)];
t_vec = linspace( t_fft(1), t_fft(end), (diff(t_fft)/t_resolution) +1);

spec_d = [];
spec_t = [];
for tIdx = 1:length(t_vec)
    % (1) Indexing
    idx = max(find( t<(t_vec(tIdx)))) - win_size*.5 :...
        max(find( t<(t_vec(tIdx))))   + win_size*.5 -1 ;
    actual_t = t(idx);
    if tIdx==1, han=hanning(length(idx))'; end
    [fft_d,spec_f]= fft_half( han .* x(idx), srate);
    spec_d( size(spec_d,1)+1 , :) = fft_d;
    spec_t( length(spec_t)+1 ) = mean(actual_t);
end
spec_d = abs(spec_d);

end

%% Subfunctions
function [s,f]=fft_half(x,Fs)
N=(length(x)); k=0:N-1; T=N/Fs; f=k/T;
cutOff = ceil(N/2); f = f(1:cutOff);
nTrials = size(x, 1);
if nTrials == 1
    s = fft(x)/N*2; % normalize the data
    s = s(1:cutOff); % Single trial FFT
else
    s = [];
    for trialIdx = 1:nTrials
        s_temp = fft(x(trialIdx,:))/N*2;
        s_temp = s_temp(1:cutOff); % Single trial FFT
        s = [s; s_temp];
    end
end
end
function [idx,short] = hb_findIdx( range, fullData )
short=false;
idx = max(find( fullData < range(1)))+1:max(find(fullData<range(2)));
if length(idx)==0, idx = 1:max(find(fullData<range(2))); end
if range(2) > fullData(end), short=1; end
end

