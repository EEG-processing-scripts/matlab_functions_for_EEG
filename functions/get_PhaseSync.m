function PLV = get_PhaseSync(x, y, sd)
% Usage: PLV = get_PhaseSync(x, y, [sd])
%
% Calculating phase locking value (PLV) from filtered
% time-series signal x and y
%
% -- input form --
% x, y: Filtered EEG signal (1-D vector)
% sd: Standard deviation of outlier-cutting routine. Highly
% recommended to set around 3-6.
%
% 2019-09-10
%
% -- Reference --
% Lachaux, J. P., Rodriguez, E., Martinerie, J., & Varela, F. J. (1999). 
% Measuring phase synchrony in brain signals. Human Brain Mapping, 8(4), 
% 194?208. http://www.ncbi.nlm.nih.gov/pubmed/10619414
% 
if nargin < 3, sd = []; end
h_x = angle(hilbert(x(:))); % hilbert angle of signal x
h_y = angle(hilbert(y(:))); % hilbert angle of signal y
ang_diff = h_x - h_y; % angle difference
if ~isempty(sd)
    ang_diff(find(ang_diff< -1*std( ang_diff )*sd))=nan;
    ang_diff(find(ang_diff>  1*std( ang_diff )*sd))=nan;
end
PLV = abs(nanmean(exp(1i* ang_diff)));

end
