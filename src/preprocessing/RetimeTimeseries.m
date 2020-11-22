function [retimed_signal] = RetimeTimeseries(signal,T,method,name)
% Converts signal data format into equally spaced timetable. timesteps are 
% set every T minutes, time gaps are filled with nan. signal data is a 
% structure with time and values fields
% OUTPUT:
% retimed_signal = processed data
% INPUT:
% signal = original data
% T: sampling time of timetable
% method: how to solve collisions if values belong to the same time-bin

if isempty(signal.values)
    dummy_t=datetime(datestr(now));
    retimed_signal=timetable(0,'VariableNames',{name},'Rowtimes',dummy_t);
else
    signal=timetable(signal.values,'VariableNames',{name},'Rowtimes',datetime(datestr(signal.time)));
    
    if strcmp(method,'sum')==1 %if the method is the sum, it's important to make a dateshift
        signal.Time=dateshift(signal.Time,'start','minute');
        signal.Time.Minute=round(signal.Time.Minute/T)*T;
    end
    
    retimed_signal=retime(signal,'regular',method,'TimeStep',minutes(T));
end

end

