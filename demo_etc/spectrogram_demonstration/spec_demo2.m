% close all;
addpath subfunctions
load('subfunctions/sampledat.mat');

clf;
srate = 2000;
spec = zeros([1001,86]);
moving_factor = 0: .1 : 8.5;
xx = 1:size(spec,1);
idx = 1 ;
real_t = [];

for mv = moving_factor
    %% Data selection
    subplot(4,1,1); hold off;
    plot(t, x , 'k');
    axis tight;
    xlabel('Time (s)');
    ylabel('Amptd (\muV)');
    title('Single trial EEG' );
    
    target_window = [-3.5 -2.5] + mv;
    t_idx = hb_findIdx( target_window, t );
    
    hold on;
    plot( t(t_idx), x( t_idx ), 'r' , 'LineWidth', 1);
    set(gca, 'YTick', []);
    set(gca, 'FontSize', 12, 'Box', 'off', 'LineWIdth', 2);
    
    %% Hanning window application
    subplot(4,3,4); hold off;
    plot( x( t_idx ) , 'r');
    set(gca, 'XTick', []); set(gca, 'YTick', []);
    title('Selected data');
    axis tight;
    ylim([-3 3]);
    xlabel('Time')
    ylabel('Amptd (\muV)');
    set(gca, 'FontSize', 12, 'Box', 'off', 'LineWIdth', 2);
    
    kernel = hanning(length(t_idx)); tt = 'Hanning';
    alpha = 5;
    kernel = gausswin( length(t_idx), alpha ) ; tt = ['Gauss. (\alpha=' num2str(alpha) ')'] ;
    
    subplot(4,3,5); hold off;
    plot(kernel, 'k');
    axis tight;
    title([tt ' window (temporal kernel)']);
    ylim([0 1]);
    set(gca, 'XTick', []);
    xlabel('Time')
    ylabel('Weight');
    set(gca, 'YTick', [0 1]);
    set(gca, 'FontSize', 12, 'Box', 'off', 'LineWIdth', 2);
    
    subplot(4,3,6); hold off;
    scaled_data =  x( t_idx )' .* kernel;
    plot(scaled_data, 'b-');
    title('Weighted data');
    axis tight;
    ylim([-3 3]);
    set(gca, 'XTick', []); set(gca, 'YTick', []);
    xlabel('Time')
    ylabel('Weighted Amptd (\muV)');
    set(gca, 'FontSize', 12, 'Box', 'off', 'LineWIdth', 2);
    
    %% Single-window FFT
    subplot(4,1,3); hold off;
    [fft_result_ori] = positiveFFT( x( t_idx ), 2000, 0);
    [fft_result_weight, frequency] = positiveFFT(scaled_data', 2000, 0);
    stem( frequency, abs(fft_result_ori).^2, 'ro' );
    hold on;
    stem( frequency, abs(fft_result_weight).^2, 'bs', 'MarkerFaceColor', 'b' );
    spec(1:length(fft_result_weight), idx) = abs(fft_result_weight).^2;
    legend({'Raw EEG', 'Weighted EEG'}, 'FontSize', 12);
    real_t( idx ) = nanmean( t(t_idx));
    idx = idx+1;
    set(gca, 'YTick', []);
    ylabel('Power (\muV^2)');
    xlabel('Freq (Hz)');
    xlim([1 40]);
    title('FFT result (of weighted data)');
    set(gca, 'FontSize', 12, 'Box', 'off', 'LineWIdth', 2);
    
    %% Spectrogram
    subplot(4,1,4); hold off;
    imagesc(xx, frequency, spec );
    ylim([1 40]);
    set(gca, 'XTick', []);
    colormap jet;
    axis xy;
    title('Power spectrogram');
    xlabel('Time'); ylabel('Freq (Hz)')
    drawnow;
    
end

%% Smooth spectrogram
subplot(4,1,4); hold off;
imagesc(real_t, frequency, imresize( spec, 5, 'cubic' ));
xlim([t(1), t(end)]);
ylim([1 40]);
xlabel('Time (s)'); ylabel('Freq (Hz)');
colormap jet;
axis xy;
title('Power spectrogram');
set(gca, 'FontSize', 12, 'Box', 'off', 'LineWIdth', 2);
