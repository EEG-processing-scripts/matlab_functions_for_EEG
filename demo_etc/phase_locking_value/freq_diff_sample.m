clear all; figure(1); clf; hold on

% Wave generator
srate = 1000; dura = 1; % sec
freq = [10 13]; % Hz
wave1 = MakeBeep( freq(1), dura, srate ); wave1 = wave1(1:end-1);
wave2 = MakeBeep( freq(2), dura, srate ); wave2 = wave2(1:end-1);
x = [wave1, wave1, wave1];
y = [wave1, wave2, wave1];

% Signal visualization
subplot(3,1,1);
t = linspace(1/srate, dura, length(x));
plot(t,x, 'r.-', t, y, 'b-');
legend({'x','y'}, 'FontSize', 12);
ylabel('Value (a.u.)');
xlabel('Time (sec)');
title(['Dummy signal x, y (Actual \Deltaw = ' num2str(diff(freq)) ' Hz)'])
set(gca, 'FontSize', 12, 'Box', 'off', 'LineWidth', 2);

% Get IFD (instant freq diff)
[ifd, h_x, h_y, ang_diff] = hb_get_IFD( x, y, srate );

% Angle difference visualization
subplot(3,1,2);
plot( t, h_x, 'r.-', t, h_y, 'b-'); hold on
plot( t, ang_diff, 'k', 'LineWidth', 2)
legend({'x_\phi','y_\phi', '\Delta\phi'}, 'FontSize', 12);
ylabel('\Delta\phi (rad)');
xlabel('Time (sec)');
set(gca, 'FontSize', 12, 'Box', 'off', 'LineWidth', 2);

% Freq difference visualization
subplot(3,1,3);
plot( t(1:end-1), ifd , 'k', 'LineWidth', 2);
ylabel('\Deltaw (Hz)');
xlabel('Time (sec)');
hold on; plot( xlim, [0 0], 'k--' );
ylim([-1 1]*10);
title(['Instantaneous frequency difference'])
set(gca, 'FontSize', 12, 'Box', 'off', 'LineWidth', 2);

function [ifd, h_x, h_y, ang_diff] = hb_get_IFD( x, y, srate )
h_x = angle(hilbert(x)); h_y = angle(hilbert(y));
ang_diff = h_x - h_y;
freqF = srate/(2*pi); ifd = freqF * diff( unwrap(ang_diff));
end
function x = hb_make_beep(f, dura, srate)
x = sin(2*pi*f*(0:dura*srate)/srate);
end
