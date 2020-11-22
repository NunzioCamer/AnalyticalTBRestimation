% --------------------------------------------------- %
% ---------------- Nunzio Camerlingo ---------------- %
% -------------- University of Padova --------------- %
% --------------------- May 2020 -------------------- %
% --------------------------------------------------- %


% ---------------------- Main ----------------------- % 

clear; close all; clc

addpath(genpath('src'));
addpath(genpath('utils'));
addpath(genpath('libs'));

type_of_analysis = 1; %0=synthetic data, 1=real-world data


%% -----------------------------------------------------------------------

switch type_of_analysis
    case 0 %synthetic data

    % Generate synthetic data and compute estimation error    
    type = 'bernoulli';
    P11 = 0.8595; %probability of remaining in hypoglycemia
    P00 = 0.9965; %probability of remaining out of hypoglycemia
    [~, mu0, ~, alpha] = generateCorrelatedBernulli(1,P11,P00);
    [data,errstima,sigma2]=generate(type,'N',1000,'N_rip',5000,'mu0',mu0,'alpha',alpha,'P00',P00,'P11',P11); %generate repetition of data and compute estimation error

    
    % Visual evaluation of results    
    visual_evaluation(errstima,alpha,sigma2,type);
    

    
%% -----------------------------------------------------------------------
    case 1 %real-world data
        if ~exist('data_CGMonly')
            error('main: Data can be downloaded at https://t1dexchange.org/research/biobank/');
        else
            CGMdata = RBGData_PreProcessing(data_CGMonly);
        end

        CGM_sampling = 5;
        N_days = 150;
        wind_step = 24*60/CGM_sampling; %1 day        

        [dich_data,CGM_data] = dichotomize_CGM(CGMdata,Ndata);
        [mu0,sigma2,alpha,CGM_data] = estimate_ground_truth(CGM_data,dich_data,CGM_sampling,0);
        
        min_wind_length = wind_step; %minimum window where computing the estimation error        
        unoverlapped_windows = 0; %0=windows are overlapped of overlapping step; 1=windows are unoverlapped 
                
        % Compute the error in the estimation of time in hypoglycemia
        est_err = compute_TBR_estimation_error(CGMdata,mu0,CGM_sampling,N_days,wind_step,min_wind_length,unoverlapped_windows);
        
        % Visual evaluation of results   
        plot_results(errstima,prctile(alpha,95),mean(sigma2),wind_step);
        
end
