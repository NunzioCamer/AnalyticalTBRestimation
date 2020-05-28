function [dich_data_out,data_out] = dichotomize_CGM(data,N)
% Dichotomize CGM data assigning 1 when CGM shows hypoglycemia and 0
% otherwise. Remove subjects with more than 30% missing values and less
% than N data
% OUTPUT: 
% dich_data_out = dichotomized version of CGM data
% data_out = CGM data
% INPUT:
% data = CGM data
% N = number of samples

n_subj = length(data);
data_out = nan(n_subj,N);
dich_data_out = nan(n_subj,N);


for idx_subj = 1:n_subj
    if length(data(idx_subj).values)>= N && length(find(isnan(data(idx_subj).values(1:N)))) <= 0.3*N
        data_out(idx_subj,:) = data(idx_subj).values(1:N);
    end
end

to_delete = [];
for idx_subj = 1:n_subj
    if isempty(find(~isnan(data_out(idx_subj,:))))
        to_delete = [to_delete,idx_subj];
    else
        for idx_sample = 1:length(data_out(idx_subj,:))
            if ~isnan(data_out(idx_subj,idx_sample)) && data_out(idx_subj,idx_sample)<=70
                dich_data_out(idx_subj,idx_sample) = 1;
            end
            if ~isnan(data_out(idx_subj,idx_sample)) && data_out(idx_subj,idx_sample)>70
                dich_data_out(idx_subj,idx_sample) = 0;
            end
        end          
        
    end
end

dich_data_out(to_delete,:) = [];
data_out(to_delete,:) = [];

