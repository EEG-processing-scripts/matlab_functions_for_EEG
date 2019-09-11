%% (0) Set environment
close all; clear all

% create a directory to save figures
fig_dir = 'figures/';
if ~isdir(fig_dir)
    mkdir(fig_dir);
    disp(['Figure directory [' pwd '/' fig_dir '] is created']);
end
addpath functions

% import core functions
func_spectrogram = @get_Spectrogram;
func_timelag     = @get_TimeLag_xcorr;
func_freqdiff    = @get_InstFreqDiff;
func_synchrony   = @get_PhaseSync;

%% (1) Amplitude spectrogram
figure(1); clf; set(gcf, 'Color', [1 1 1]);

% Generate model EEG signal
srate = 1000; 
unit_duration = 10; % sec
freq = [5 10 25]; % Hz
wave1 = sin(2*pi*freq(1)*(0:unit_duration*srate)/srate);
wave2 = sin(2*pi*freq(2)*(0:unit_duration*srate)/srate);
wave3 = sin(2*pi*freq(3)*(0:unit_duration*srate)/srate);
x = [wave1, wave2, wave3];
t = 1/srate:1/srate:length(x)/srate;

% Calculate spectrogram
[spec_d, spec_t, spec_f] = func_spectrogram( x, t );

% Visualization of time-series signal
subplot(2,1,1);
plot( t, x ) 
axis tight;
xlabel('Time (s)');
xlims = xlim;
title([ 'Original time-series signal (Frequency: ' ...
    num2str(freq(1)) ', ' num2str(freq(2)) ', and ' num2str(freq(3)) ' Hz)']);
set(gca, 'FontSize', 11, 'LineWidth', 2' , 'Box', 'off' );

% Visualization of spectrogram
subplot(2,1,2);
imagesc( spec_t, spec_f, spec_d'); 
ylim([0 50])
xlim(xlims)
colormap jet; axis xy;
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title([ 'Time-frequency domain representation']);
set(gca, 'FontSize', 11, 'LineWidth', 2' , 'Box', 'off' );
drawnow;

saveas(gcf, [fig_dir 'Figure1-spectrogram.png']);

%% (2) Time lag
figure(2); clf; set(gcf, 'Color', [1 1 1]);

% Generate model EEG signal
fNoise1 = 10; % Shared noise of x, y
fNoise2 = 1; % Unique noise of y
actual_lag = 3;
len = 300;
x = sin(1:len) + rand(1,len)*fNoise1;
y = x(1+actual_lag:end)+rand(1,len-actual_lag)*fNoise2;
x = x(1:length(y)) - nanmean(x);
y = y - nanmean(y);

% Get time lag 
[lag, coeff_func, lag_func] = func_timelag( x, y );

% Signal visualization
subplot(2,1,1); 
t = 1:length(x);
plot( t, x, 'k', t, y, 'r' );
xlabel('Time (a.u.)'); 
ylabel('Voltage');
legend(['X - Original signal'], ['Y - Shifted signal (leading by ' num2str(actual_lag) ')'] );
set(gca, 'FontSize', 11, 'LineWidth', 2' , 'Box', 'off' );
title(['Model EEG signal (Actual lag = ' num2str(actual_lag) ')']);

% Time-lag visualization (cross correlation function)
subplot(2,1,2); hold off;
plot( lag_func, coeff_func, 'ks-' );
hold on;
plot( lag_func(lag), coeff_func(lag), 'r*' );
xlim([-1 1]*30);
xlabel('Lag'); ylabel('Corr. coeff (r)');
title([ 'Cross-correlation function (Estimated lag = ' num2str(lag_func(lag)) ')' ]);
set(gca, 'FontSize', 11, 'LineWidth', 2' , 'Box', 'off' );
plot( [0 0], ylim, 'k--' );

saveas(gcf, [fig_dir 'Figure2-timelag.png']);

%% (3) Instant Freq Difference
figure(3); clf; set(gcf, 'Color', [1 1 1]);

% Wave generator
srate = 1000; 
unit_duration = 1; % sec
freq = [6 8]; % Hz
wave1 = sin(2*pi*freq(1)*(0:unit_duration*srate)/srate); wave1 = wave1(1:end-1);
wave2 = sin(2*pi*freq(2)*(0:unit_duration*srate)/srate); wave2 = wave2(1:end-1);
x = [wave1, wave1];
y = [wave1, wave2];

% Get IFD (instant freq diff)
[ifd, h_x, h_y, ang_diff] = func_freqdiff( x, y, srate );

% Signal visualization
subplot(3,1,1);
t = linspace(1/srate, unit_duration*2, length(x));
plot(t,x, 'r.-', t, y, 'b-');
legend({'x','y'}, 'FontSize', 12);
ylabel('Value (a.u.)');
xlabel('Time (sec)');
title(['Dummy signal x, y (Actual \Deltaw = ' num2str(diff(freq)) ' Hz)'])
set(gca, 'FontSize', 12, 'Box', 'off', 'LineWidth', 2);

% Angle difference visualization
subplot(3,1,2);
plot( t, h_x, 'r.-', t, h_y, 'b-'); hold on
plot( t, ang_diff, 'k', 'LineWidth', 2)
legend({'x_\phi','y_\phi', '\Delta\phi'}, 'FontSize', 12);
title(['Angle difference'])
ylabel('\Delta\phi (rad)');
xlabel('Time (sec)');
set(gca, 'FontSize', 12, 'Box', 'off', 'LineWidth', 2);

% Freq difference visualization
subplot(3,1,3);
plot( t(1:end-1), ifd , 'k', 'LineWidth', 2);
ylabel('\Deltaw (Hz)');
xlabel('Time (sec)');
hold on; plot( xlim, [0 0], 'k--' );
ylim([-1 1]*4);
title(['Instantaneous frequency difference'])
set(gca, 'FontSize', 12, 'Box', 'off', 'LineWidth', 2);

saveas(gcf, [fig_dir 'Figure3-instfreqdiff.png']);

%% (4) Phase Synchrony 

% Generate dummy signal
srate = 1000; 
unit_duration = 1; % sec
freq = [6 8]; % Hz
wave1 = sin(2*pi*freq(1)*(0:unit_duration*srate)/srate);
wave2 = sin(2*pi*freq(2)*(0:unit_duration*srate)/srate);

% Calculate phase-locking value
plv1 = func_synchrony( wave1, wave1 );
plv2 = func_synchrony( wave1, wave2 );
disp(['PLV of same signal [wave1, wave1] = ' num2str(plv1)])
disp(['PLV of different signal [wave1, wave2] = ' num2str(plv2)])
