function est_err = compute_TBR_estimation_error(CGM_data,mu0,CGM_sampling,N_days,wind_step,min_wind_length,unoverlapped_windows)
% compute the estimation error of time in range

% OUTPUT:
% est_err = estimation error of time in range
% INPUT:
% CGM_data = data
% mu0 = ground-truth TBR
% CGM_sampling = sampling time of CGM (5-min for RBG dataset)
% N_days = number of days on which perform the analysis
% wind_step = step between consecutive windows on which compute the estimation error
% min_wind_length = minimum length to compute estimation error
% unoverlapped_windows = flag equal to 0 if considering windows overlapped of wind_step sample

Ndata = N_days*wind_step;
n_subj = length(mu0);

est_err = nan(Ndata/min_wind_length*n_subj,N_days); %initialization of estimation error matrix
for idx_subj = 1:n_subj

    for idx_length = min_wind_length:min_wind_length:Ndata
        if unoverlapped_windows
            overlapping_step = idx_length; %to have unoverlapped windows
            windows = [1:overlapping_step:floor(Ndata/overlapping_step)*overlapping_step-overlapping_step+1];
        else
        overlapping_step = wind_step; %windows are overlapped of wind_step samples
        windows = [1:overlapping_step:Ndata-idx_length+1];
        end

        for idx_start = 1:length(windows)
            starting_point = windows(idx_start);
            ending_point = starting_point+idx_length-1;
            
            %Get CGM data and transform it to a timeseries to be fed into
            %AGATA
            glucose = CGM_data(idx_subj,starting_point:ending_point)'; %get glucose values
            time = datetime(2000,1,1,0,0,0):minutes(CGM_sampling):(datetime(2000,1,1,0,0,0)+minutes(CGM_sampling*length(glucose)-CGM_sampling)); %create a dummy time vector
            data = timetable(glucose,'VariableNames', {'glucose'}, 'RowTimes', time); %create the timetable
            
            perc_time_hypo = timeInHypoglycemia(data); %use AGATA
            
            estimated_thypo = perc_time_hypo/100;
            est_err(idx_start+(idx_subj-1)*length(windows),idx_length/wind_step-min_wind_length/wind_step+1) = estimated_thypo-mu0(idx_subj);
        end
    end
        
end


end