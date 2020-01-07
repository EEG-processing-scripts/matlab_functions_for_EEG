
%% Load sample data
clear all
close all;
load Signal.mat

%% Get Wavelet
Freq = 1 : 1 : 100; % Hz
Fs = 2000;

how_smaller = 0.05;% Resize (make it smaller!) is strongly recommended
[Coeff, T, F] = get_wv_spec( Signal, Time, Freq, Fs, how_smaller );

% WVs.t = T;
% WVs.f = F;
% WVs.data(:,:,chanIdx,triaIdx) = Coeff;

%% Plot 
xlims = [-1 2];
ylims = [1 100];

subplot(3,1,1);
plot( Time, Signal, 'k');
xlabel('Time (sec)'); ylabel('Amptd (V)');
xlim(xlims);
title('Raw data');
cb=colorbar;

subplot(3,1,2);
imagesc( T, F, abs(Coeff) );
axis xy; colormap jet;
xlabel('Time (sec)'); ylabel('Freq (Hz)');
title(['Spectrogram (Wavelet, T-downsample factor = ' num2str(how_smaller*100) ' %)']);
ylim([0 100]);
cb=colorbar;
xlim(xlims);
ylim(ylims);

subplot(3,1,3);
imagesc( Spec_t, Spec_f, abs(Spec_fft)' );
axis xy; colormap jet;
xlabel('Time (sec)'); ylabel('Freq (Hz)');
title('Spectrogram (FFT)');
ylim([0 100]);
cb=colorbar;
xlim(xlims);
ylim(ylims);

drawnow;






