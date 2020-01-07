function [yy] = hb_filtwithHds(xx, Hd1,Hd2)
% function [yy] = hb_filtwithHds(xx, Hd1,Hd2)

%% Class convert
input_class= class(xx);
try
    if ~(min(input_class == 'double'))
        xx = double(xx);
    end
end

%% Hd1 Filtering
filt_1 = filtfilt(Hd1.SOSMatrix, Hd1.ScaleValues, xx);
%% Hd2 Filtering
filt_2 = filtfilt(Hd2.SOSMatrix, Hd2.ScaleValues, filt_1);
yy = filt_2;

return