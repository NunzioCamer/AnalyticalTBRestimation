function [samples_in_range,time_in_range,perc_time_in_range] = timeinrange(range,CGM,CGM_sampling)
% Compute time spent inside a certain range
% OUTPUT:
% samples_in_range = number of samples spent in the range
% time_in_range = time spent in the range (depends on CGM sampling period)
% perc_time_in_range = percentage time spent in the range
% INPUT:
% range = glycemic range
% CGM = data
% CGM_sampling = sampling period of CGM sensor (5 min for RBG data)

minrange=min(range);
maxrange=max(range);

curr_wind_length = sum(~isnan(CGM)); %useful sample in current window (i.e., not nan)



samples_in_range=length(find(CGM<=maxrange & CGM>=minrange));
time_in_range = samples_in_range*CGM_sampling;
perc_time_in_range = samples_in_range/curr_wind_length*100;

end

