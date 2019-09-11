# eeg_processing_scripts

** Matlab functions for analyzing EEG oscillations, including spectrogram, phase synchrony, etc.. **

This repository are built to share EEG signal processing scripts used in the original research of XXX et al. (*in revision*).

The script [demo.m] contains example usage of each function.

Information of authors and affiliation are intentionally deleted for double-blind review process, and will be updated soon.


# Contents

**1. get_Spectrogram.m**

*Usage: [spec_d, spec_t, spec_f] = get_Spectrogram( x, t, win_size, t_resolution )*

Calculating amplitude spectrogram from signal x and time-vector t. 

-- input form --

x: Raw EEG signal (1-D vector)

y: Time vector (in millisecond resolution)

win_size: Size of sliding moving window (default: 2^10)

t_resolution: Jump size of sliding moving window (unit: sec, default: 0.1 sec)


**2. get_TimeLag_xcorr.m**

*Usage: lag = get_TimeLag_xcorr(x, y, maxlag)*

Calculating time-lag between two time-series signal x, and y

-- input form --

x, y: (Filtered) EEG signal (1-D vector)

maxlag: Maximum time lag to consider (default: half signal length)



**3. get_PhaseSync.m**

*Usage: PLV = get_PhaseSync(x, y, [sd])*

Calculating phase locking value (PLV) from filtered

time-series signal x and y

-- input form --

x, y: Filtered EEG signal (1-D vector)

sd: Standard deviation of outlier-cutting routine (Highly recommended to set around 3-6).


**4. get_InstFreqDiff.m**

*Usage: ifd = get_InstFreqDiff(x, y, srate)*

Calculating instantaneous frequency differnece (IFD) from filtered time-series signal x and y

-- input form --

x, y: Filtered EEG signal (1-D vector)

srate: Sampling rate


