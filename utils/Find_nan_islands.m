function [short_nan,long_nan,nan_start,nan_end] = Find_nan_islands(x,TH)
% Locate nan sequences in array x, classifies them based on their length
% (longer or not than the specified threshold TH)
% OUTPUT:
% short_nan: indices of short nan sequences
% long_nan: indices of long nan sequences
% nan_start: start of nan sequences
% nan_start: end of nan sequences
% INPUT:
% x = data
% TH = threshold to distibguish between long and short NaN

% make input as column
x=x(:);

%% locate nan sequences

nan_ind=isnan(x);
nan_ind=double(nan_ind);
tmp = find(diff(nan_ind));

% if nan sequence starts from first index
firstIsNan=nan_ind(1);
if firstIsNan
    tmp=[0; tmp];
end
% if nan sequence ends on last index
lastIsNan=nan_ind(end);
if lastIsNan
    tmp=[tmp; length(x)];
end

if length(tmp)==1
    % only one nan sequence
    N=length(find(nan_ind));
    nan_intervals=[tmp+1 tmp+N];
    nan_sequences_length=N;
else
    % more than one nan sequence
    nan_intervals=[tmp(1:2:end) tmp(2:2:end)];
    nan_intervals(:,1)=nan_intervals(:,1)+1;
    nan_sequences_length = nan_intervals(:,2)-nan_intervals(:,1)+1;
end

% start and end indices of each sequence
nan_start=nan_intervals(:,1);
nan_end=nan_intervals(:,2);

%% classification based on length

% find long and short sequence based on th
long_seq=nan_intervals(nan_sequences_length>=TH,:);
short_seq=nan_intervals(nan_sequences_length<TH,:);

% indices of long nan sequences
long_nan=[];
for j=1:size(long_seq,1)
    long_nan=[long_nan long_seq(j,1):1:long_seq(j,end)];
end

% indices of short nan sequences
short_nan=[];
for j=1:size(short_seq,1)
    short_nan=[short_nan short_seq(j,1):1:short_seq(j,end)];
end



end