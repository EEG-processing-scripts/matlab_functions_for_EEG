function EEG = hiobeen_spectrogram( EEG, fft_win_size, t_resolution, freq_cut )
%% Calculating spectrogram from EEG dataset
%
% EEG=hiobeen_spectrogram( EEG )
% EEG=hiobeen_spectrogram( EEG, fft_win_size )
% EEG=hiobeen_spectrogram( EEG, fft_win_size, t_resolution )
% EEG=hiobeen_spectrogram( EEG, fft_win_size, t_resolution, freq_cut )
%
% >>>> hiobeen.han@kaist.ac.kr. 2019-10-09.
%

%% Defulat condition
if nargin < 4
    freq_cut = 150; % Hz
end; if nargin < 3
    t_resolution = .05;
end; if nargin < 2
    fft_win_size = 2^11;
end

% Make time vector 't' with second-resolution
if ~isfield(EEG, 'times')
    disp(['Time vector (EEG.times) does not exist!'])
    EEG.times = linspace(0, size(EEG.data,2)/EEG.srate, size(EEG.data,2) );
end

% Time unit should be in "Seconds"
minimum_hz = 100; % Minimum range of EEG data sampling rate
if mean(diff(EEG.times)) > (1/minimum_hz)
    warning(['Time vector (EEG.times) has milisecond-unit resolution!'])
    t = EEG.times / 1000;
else
    t = EEG.times;
end
t_fft = [t(1)+(((fft_win_size*.5)+1)/EEG.srate), t(end)-(((fft_win_size*.5)+1)/EEG.srate)];
t_vec = linspace( t_fft(1), t_fft(end), (diff(t_fft)/t_resolution) +1);

%% Pre-occupy memory space
[~,f]=hiobeen_fft( 1:fft_win_size, EEG.srate );
n_f =  max(find(f < freq_cut))+1;
n_t = length(t_vec);
n_trial = size( EEG.data, 3 );
n_ch = size( EEG.data, 1) ;

%% Output formation
EEG.PSD = [];
EEG.PSD.data = single(nan( [n_t, n_f, n_ch, n_trial]));
EEG.PSD.nfft = fft_win_size;
EEG.PSD.freq_cut = freq_cut;
EEG.PSD.valid_channels = ( nanstd( EEG.data(:,:,1), 0, 2 ) > 0 )';
EEG.PSD.f = f(1:n_f);

%% Debriefing input
disp([ '------- Initiating hiobeen_spectrogram() -------' ])
disp([ '. sampling rate = ' num2str(EEG.srate) ' Hz' ])
disp([ '.. n_trials = ' num2str(n_trial ) ])
disp([ '... fft_window_size = ' num2str( fft_win_size/EEG.srate ) ' sec']);
disp([ '.... frequency_bin = ' num2str( n_f ) ' bin (0-' num2str(freq_cut) ' Hz)'])
disp([ '..... t_resolution = ' num2str( t_resolution ) ' sec'])
if ~min(EEG.PSD.valid_channels )
    warning( ['Bad channel is detected! ' ['Channel [' num2str( find(~EEG.PSD.valid_channels(:)') ) ']']] )
end

%% Get Actual T
idx_collection = single([]);
for tIdx = [1, length(t_vec)]
    idx_collection(tIdx,:) = [max(find( t<(t_vec(tIdx)))) - fft_win_size*.5,...
        (max(find( t<(t_vec(tIdx))))   + fft_win_size*.5-1) ];
end
idx_collection(:,1) = linspace( idx_collection(1,1), idx_collection(end,1), length(t_vec) );
idx_collection(:,2) = linspace( idx_collection(1,2), idx_collection(end,2), length(t_vec) );
idx_collection = round(idx_collection);
EEG.PSD.t = t( round(mean(idx_collection,2)) );

dif = diff(idx_collection')';
short = find( ~[dif == (fft_win_size-1)]);
idx_collection(short,2) = idx_collection(short,2)+1;

%% Calculation & Return
hann = hanning( idx_collection(1,2)-idx_collection(1,1)+1 )';
for chanIdx = find( EEG.PSD.valid_channels )
    disp(['Calc ePSD.. Channel:' num2str(chanIdx) ] )
    for trialIdx = 1:n_trial
        epoch = EEG.data(chanIdx, :, trialIdx);
        for tIdx = 1:length(t_vec)
%             length(idx_collection(tIdx,1):idx_collection(tIdx,2))
%             length(hann)
            ii = idx_collection(tIdx,1):idx_collection(tIdx,2); 
            d =  hann .* epoch(ii(1:length(hann)));
            [x,f]= hiobeen_fft(d, EEG.srate);
            EEG.PSD.data(tIdx,:,chanIdx,trialIdx) = abs(x(1:n_f));
        end
    end
end

%% Subfunctions
function [X,freq]=hiobeen_fft(x,Fs)

N=(length(x));  %get the number of points
k=0:N-1;        %create a vector from 0 to N-1
T=N/Fs;         %get the frequency interval
freq=k/T;       %create the frequency range
cutOff = ceil(N/2);
freq = freq(1:cutOff);
X=fft(x)/N*2; % normalize the data
X = X(1:cutOff); % Single trial FFT
return



function [idx,short] = hb_findIdx( range, fullData )
% function idx = hb_findIdx( range, fullData )

short=false;
idx = max(find( fullData < range(1)))+1:max(find(fullData<range(2)));

if length(idx)==0
    %     idx
    idx = 1:max(find(fullData<range(2)));
end

if range(2) > fullData(end)
    short=1;
end

return