%% Prepare dataset
close all;
fontsize = 13; linewidth = 2;
addpath subfunc
sampledata = load('CFC_sampledata.mat');
idx = 7000:9000;
dat = sampledata.x(idx); % Slow frequency
t = sampledata.t(idx);
srate = sampledata.srate;

% Plot raw data
figure(1); clf;
subplot(1,2,1); hold off;
plot( t, dat);
axis tight;
xlabel('Time (msec)');
ylabel('Amptd (\muV)');
axis tight;
xlabel('Time (msec)');
ylabel('Amptd (\muV)');
title('Raw data (time domain)');
set(gca, 'FontSize', fontsize, 'LineWidth', linewidth, 'Box', 'off');

subplot(1,2,2); hold off;
positiveFFT( dat, srate, true );
xlim([1 100]);
title('Raw data (freq domain)');
set(gca, 'FontSize', fontsize, 'LineWidth', linewidth, 'Box', 'off');
drawnow;

%% Set CFC parameters
disp(['Setting calc parameters for CFC...']);
CFC = [];
CFC.width_x = 0.5; % +- 0.5 Hz
CFC.width_y = 5; % +- 5 Hz
CFC.band_x = 3:1:15; % From 2 Hz to 12 Hz, interval = 1;
CFC.band_y = 20:5:150; % From 20 Hz to 100 Hz, interval = 5;
CFC.order = 10; % Filter Order
CFC.downsample = .20;
CFC.srate = srate * CFC.downsample;

% Prepare Filter Bank
disp(['Preparing filters ...']);
CFC.filter_x = {};
CFC.filter_y = {};
for xIdx = 1:length(CFC.band_x)
    [CFC.filter_x{xIdx,1}, CFC.filter_x{xIdx,2} ] = ...
        hb_getBandpassHd(CFC.band_x(xIdx)+[-1 1]*CFC.width_x, ...
        CFC.order, CFC.srate);
end
for yIdx = 1:length(CFC.band_y)
    [CFC.filter_y{yIdx,1}, CFC.filter_y{yIdx,2} ] = ...
        hb_getBandpassHd(CFC.band_y(yIdx)+[-1 1]*CFC.width_y, ...
        CFC.order, CFC.srate);
end
disp(['Done.']);

%% Calculation: Single-trial CFC 
figure(2); clf;

nbinX = 50; % <- Change this to make computation fast (i.e., Recommended: 20-30)
nbinY = nbinX;
pos = linspace(-pi, pi, nbinX);

comodulogram = nan([length(CFC.band_x), length(CFC.band_y)]);
contrasts = nan([length(CFC.band_x), length(CFC.band_y)]);

dat_downsample = imresize( dat, [1, size(dat,2)* CFC.downsample] );

for xIdx = 1:length(CFC.band_x) % Phase freq band
        
    phase_dat = hb_filtwithHds( dat_downsample, CFC.filter_x{ xIdx, 1}, CFC.filter_x{xIdx, 2} );
    for yIdx = 1:length(CFC.band_y) % Amptd freq band
        amptd_dat = hb_filtwithHds( dat_downsample, CFC.filter_y{ yIdx, 1}, CFC.filter_y{yIdx, 2} );
        
        [jphist, PLV, MI, MeanAmp, amplitudes] = ...
            hb_couplings( phase_dat, amptd_dat, nbinX, nbinY );
        
        comodulogram( xIdx, yIdx ) = MI;
        contrasts( xIdx, yIdx ) = nanstd(jphist(:));
        
        %% Visualization
        resize_factor = 50; % Increase resolution
        interpoloate_method = 'cubic'; % cubic, bilinear, nearest, etc..
        
        % 1 - Comodulogram (phase amptd)
        subplot(2,2,1); hold off;
        imagesc( CFC.band_x, CFC.band_y, comodulogram' );
        if xIdx == length(CFC.band_x) && yIdx == length(CFC.band_y)
            imagesc( CFC.band_x, CFC.band_y, ...
                imresize( comodulogram', resize_factor, interpoloate_method ));
        end
        axis xy;
        colormap jet;
        xlabel('Slow Freq (Hz)');
        ylabel('Fast Freq (Hz)');
        cb=colorbar;
        ylabel(cb, 'MI (a.u.)' );
        title(['Comodulogram (phase-amplitude coupling)']);
        set(gca, 'FontSize', fontsize, 'LineWidth', linewidth, 'Box', 'off');
        
        
        % 2 - Comodulogram (phase phase)
        subplot(2,2,2); hold off;
        imagesc( CFC.band_x, CFC.band_y, contrasts' );
        if xIdx == length(CFC.band_x) && yIdx == length(CFC.band_y)
            imagesc( CFC.band_x, CFC.band_y, ...
                imresize( contrasts', resize_factor, interpoloate_method ));
        end
        axis xy;
        colormap jet;
        xlabel('Slow Freq (Hz)');
        ylabel('Fast Freq (Hz)');
        cb=colorbar;
        ylabel(cb, 'Contrast (a.u.)' );
        title(['Comodulogram (phase-phase coupling)']);
        set(gca, 'FontSize', fontsize, 'LineWidth', linewidth, 'Box', 'off');
        drawnow;
        
        hz_x = [ num2str( CFC.band_x(xIdx) ) ' Hz' ];
        hz_y = [ num2str( CFC.band_y(yIdx) ) ' Hz' ];
        
        % 3 - Phase-amplitude coupling
        subplot(2,2,3);  hold off;
        plot( pos, smooth( MeanAmp, 10 ), 'ks-' ); hold on;
        plot( xlim, [0 0]+nanmean(MeanAmp), 'r--' );
        xlabel([ hz_x ' Phase (rad)' ]);
        ylabel([ hz_y ' Amptd (\muV)']);
        title(['Phase-Amplitude coupling, MI=' num2str(MI)]);
        xlim([-pi pi]);
        set(gca, 'FontSize', fontsize, 'LineWidth', linewidth, 'Box', 'off');
        
        % 4 - Phase-phase coupling
        subplot(2,2,4);  hold off;
        try;joint_phase_histogram = imgaussfilt( jphist*100, 1 )';
        catch; joint_phase_histogram =jphist; end
        imagesc( pos, pos, joint_phase_histogram );
        xlabel([ hz_x ' Phase (rad)' ]);
        ylabel([ hz_y ' Phase (rad)']);
        title(['Phase-Phase coupling, Std = ' num2str(contrasts( xIdx, yIdx ))]);
        cb=colorbar;
        caxis([0 0.1]);
        ylabel(cb, 'Prob (%)' );
        set(gca, 'FontSize', fontsize, 'LineWidth', linewidth, 'Box', 'off');
        drawnow;
        
    end
end













