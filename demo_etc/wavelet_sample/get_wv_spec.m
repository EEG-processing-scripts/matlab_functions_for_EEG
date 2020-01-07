function [Coeff, T, F] = get_wv_spec( Signal, T, F, Fs, how_smaller )

Coeff = cwt(Signal ,centfrq('cmor1 -1')*Fs./F,'cmor1 -1 ');

Coeff = single(abs(Coeff));

if nargin > 4
    Coeff = imresize( Coeff, [size(Coeff,1), size(Coeff,2)*how_smaller], 'nearest' );
    T = imresize( T, [1, length(T)*how_smaller], 'nearest');
end

