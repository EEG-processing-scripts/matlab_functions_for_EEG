function [jphist, PLV, MI, MeanAmp, amplitudes, positionX] = hb_couplings( xf, yf, nbinX, nbinY )
% - - - Joint Phase Histogram - - -
% 
% [probmat, PLV, MI, MeanAmp] = hb_couplings( xf, yy, nbinX, nbinY )
% 
% -- input arguments
%    xf, yf: (bandpass-)filtered signal
%    nbinX, nbinY: number of bins
% 
% -- output arguments
%    jphist: joint-phase histogram (Phase phase coupling)
%    PLV: Phase-locking value (Lachaux, 1999)
%    MI: Modulation index of Phase(x)-Amplitude(y) coupling ...
%    MeanAmp: Amplitude of Y modulated by X's phase
%      (Modified from Tort et al. 2008, 2009 PNAS, and 2010 J Neurophysiol))
% 
% Written by HB Han, hiobeen.han@kaist.ac.kr, 2018-02-06
%

if nargin < 3
    nbinX=30; nbinY=30;
end

amplitudes = single([]);
 
xfp = angle(hilbert( xf ) );
yfp = angle(hilbert( yf ) );
yfa = abs(hilbert( yf ) );

% Detect outlying y values
cutpoint = nanmedian(yfa)+nanstd(yfa)*5;
yfa(find(yfa>cutpoint)) = nan;
 
positionX=zeros(1,nbinX);
winsizeX = 2*pi/nbinX;
for binIdxX = 1:nbinX 
    positionX(binIdxX) = -pi+(binIdxX-1)*winsizeX; 
end
positionY=zeros(1,nbinY); 
winsizeY = 2*pi/nbinY;
for binIdxY = 1:nbinY
    positionY(binIdxY) = -pi+(binIdxY-1)*winsizeY; 
end

occurences = zeros(nbinX, nbinY);
MeanAmp = zeros([1, nbinX]);
% yfas = {};
for binIdxX = 1:nbinX   
    Ix = find(xfp <  positionX(binIdxX)+winsizeX & xfp >=  positionX(binIdxX));
    temp_yfp = yfp(Ix);
    for binIdxY = 1:nbinY
        Iy =  find(temp_yfp <  positionY(binIdxY)+winsizeY & temp_yfp >=  positionY(binIdxY));
        occurences( binIdxX, binIdxY ) = occurences( binIdxX, binIdxY ) + length(Iy);
    end
    amplitudes( binIdxX , 1:length(yfa(Ix)) ) = yfa(Ix);
    MeanAmp(binIdxX) = nanmean( yfa(Ix) );
end
 
jphist = occurences / length(xfp);
PLV = abs(mean(exp(1i* (xfp-yfp))));
MI=(log(nbinX)-(-sum((MeanAmp/sum(MeanAmp)).*log((MeanAmp/sum(MeanAmp))))))/log(nbinX);
 
% % Additional calculation for PLV & MI
% if nargout > 1
% end; if nargout > 2
% end
 
return
