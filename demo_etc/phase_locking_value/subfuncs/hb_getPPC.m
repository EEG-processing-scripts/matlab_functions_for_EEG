function [c, v, n] = hb_getPPC(x_filt,y_filt)
% The input data input should be organized as:
%   Repetitions x Channel x Channel (x Frequency) (x Time)


% The output c contains the ppc, v is a leave-one-out variance estimate which is only
% computed if dojack = 1,and n is the number of repetitions in the input data.

x= (hilbert(x_filt));
y= (hilbert(y_filt));

input = [];
% input(:, 1) = x;
% input(:, 2) = y;

input(1,1,1,1,:) = x;
input(1,2,1,1,:) = y;

% input(1,:) = x_filt;
% input(2,:) = y_filt;

% input(1,1,1,:) = x_filt;
% input(2,1,1,:) = y_filt;

siz = size(input);
n = siz(1);

outsum   = nansum(input); % normalization of the WPLI
outssq   = nansum(input.*conj(input));
outsumw  = nansum(abs(input));
c        = (outsum.*conj(outsum) - outssq)./(outsumw.*conj(outsumw) - outssq); % do the pairwise thing in a handy way
  c          = reshape(c,siz(2:end)); % remove the first singular dimension

size(c)


