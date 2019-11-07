# Matlab functions for analyzing EEG oscillations, including spectrogram, phase synchrony, etc..

This repository is built to share EEG signal processing scripts used in the original research of XXX et al. (*in revision*).

The script [demo.m] contains example usage of each function.

* Related publication: [Hio-Been Han, Ka Eun Lee, & Jee Hyun Choi (2019). **Functional dissociation of theta oscillations in the frontal and visual cortices and their long-range network during sustained attention**, *eNeuro, (4)*, November 2019, ENEURO.0248-19.2019; DOI: 10.1523/ENEURO.0248-19.2019](https://www.eneuro.org/content/early/2019/11/04/ENEURO.0248-19.2019).

<br><br>

## List of contents

**1. get_Spectrogram.m**

    [spec_d, spec_t, spec_f] = get_Spectrogram( x, t, win_size, t_resolution )

*Calculating amplitude spectrogram from signal x and time-vector t.*

> - input arguments<br> x: Raw EEG signal (1-D vector)<br> y: Time vector (in millisecond resolution)<br> win_size: Size of sliding moving window (default: 2^10)<br> t_resolution: Jump size of sliding moving window (unit: sec, default: 0.1 sec)

<br>
![png](figures/Figure1-spectrogram.png)

<br><br>
**2. get_TimeLag_xcorr.m**

    lag = get_TimeLag_xcorr(x, y, maxlag)

*Calculating time-lag between two time-series signal x, and y*

> - input arguments<br> x, y: (Filtered) EEG signal (1-D vector)<br> maxlag: Maximum time lag to consider (default: half signal length)

<br>
![png](figures/Figure2-timelag.png)

<br><br>
**3. get_PhaseSync.m**

    PLV = get_PhaseSync(x, y, [sd])

*Calculating phase locking value (PLV) from filtered time-series signal x and y*

> - input arguments<br> x, y: Filtered EEG signal (1-D vector)<br> sd: Standard deviation of outlier-cutting routine (Highly recommended to set around 3-6).

<br><br>
**4. get_InstFreqDiff.m**

    ifd = get_InstFreqDiff(x, y, srate)

*Calculating instantaneous frequency differnece (IFD) from filtered time-series signal x and y*

> - input arguments<br> x, y: Filtered EEG signal (1-D vector)<br> srate: Sampling rate
<br>
![png](figures/Figure3-instfreqdiff.png)

