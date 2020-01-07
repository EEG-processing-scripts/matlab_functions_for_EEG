addpath subfuncs;
load sampledata_plv

%% Change this part
xlim_win = [1700 5450] - 700;
% xlim_win = [2700 3450] ;
% xlim_win = [2700 3450] + 700; 
band = [4 12]; % Hz


%% Do not change this part
colors = {'k', 'r'};
% band = [30 50]; % Hz

x = zerofilt( sampledata.x, 1, 50, sampledata.srate) ;
y = zerofilt( sampledata.y, 1, 50, sampledata.srate) ;
t = sampledata.t; %1000* [1:length(x) ] / sampledata.srate ;
plv = hb_getPLV( x(hb_findIdx( xlim_win, t )), y(hb_findIdx( xlim_win, t )) );

% Raw
clf;
nSp = 5;
subplot(nSp,1,1); hold off;
plot( t, x ,colors{1}); hold on; plot(t, y ,colors{2});
title('Raw')
xlim(xlim_win);
set(gca,'LineWidth',2,'FontSize',11,'Box','off');
ylabel('Voltage (mV)');

% Filt
subplot(nSp,1,2); hold off;
x_filt = zerofilt( double(x)', band(1), band(2), sampledata.srate )';
y_filt = zerofilt( double(y)', band(1), band(2), sampledata.srate )';
plot( t, x_filt,colors{1} ); hold on; plot(t, y_filt ,colors{2});
title(['Filt (' num2str(band(1)) '-' num2str(band(2)) 'Hz)']);
xlim(xlim_win);
set(gca,'LineWidth',2,'FontSize',11,'Box','off');
ylabel('Voltage (mV)');

% Angle
subplot(nSp,1,3); hold off;
h_x_filt = angle(hilbert(x_filt));
h_y_filt = angle(hilbert(y_filt));
plot( t, h_x_filt,colors{1} ); hold on; plot(t, h_y_filt ,colors{2});
title(['Hilbert instant angle, PLV = ' num2str( plv)  ]);
xlim(xlim_win);
set(gca,'LineWidth',2,'FontSize',11,'Box','off');
ylabel('\phi (rad)');

% Ang Diff 
subplot(nSp,1,4); hold off;
ang_diff = h_x_filt - h_y_filt;
plot( t, ang_diff, 'k'); 
title(['Angle difference, PLV = ' num2str( plv)  ]);
xlim(xlim_win);
ylabel('\Delta\phi (rad)');
hold on; plot( xlim, [0 0], 'b--' );
set(gca,'LineWidth',2,'FontSize',11,'Box','off');

% Freq Diff 
subplot(nSp,1,5); hold off;
freqF = sampledata.srate/(2*pi);
ang_derivate = freqF * diff( unwrap(ang_diff));
plot( t(2:end), ang_derivate, 'k') 
title('Freq difference');
ylabel('\Deltaw (Hz)');
xlim(xlim_win);
ylim([-1 1]*10);
hold on; plot( xlim, [0 0], 'b--' );
set(gca,'LineWidth',2,'FontSize',11,'Box','off');
