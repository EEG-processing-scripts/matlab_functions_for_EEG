function [spec_clean, pink_spectrum, mean_spectrum] = spectrogram_regress_pink( spec_raw, freq )
% Eliminate pink noise from spectrogram
%     Example usage:
%       [spec_clean, pink] = spectrogram_regress_pink( spec_raw, freq );
%
% [spec_raw]: spectrogram (2d matrix, time x frequency)
% [f]: frequency vector
% 
% Written by Hio-Been Han, 2020-11-08
% hiobeen.han@kaist.ac.kr
%
nT = size( spec_raw, 1 );
nF = size( spec_raw, 2 );

mean_spectrum = nanmean(spec_raw,1)';
temp_pink = regress_pink( mean_spectrum, freq);

pink_spectrum = mean_spectrum-temp_pink; % pink component
spec_clean = spec_raw - repmat(pink_spectrum',[size(spec_raw,1),1]);

end
function spectrum_clean = regress_pink( spectrum, freq )
pink = 1./freq'; if pink(1)==Inf, pink(1)=pink(2); end
[~,~,spectrum_clean] = regress(spectrum, pink);
end
