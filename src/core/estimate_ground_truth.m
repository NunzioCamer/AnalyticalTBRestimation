function [mu0,sigma2,alpha,CGM_data] = estimate_ground_truth(CGM_data,dich_data,CGM_sampling,show_figure)
% Estimate ground-truth mu0, sigma2 and alpha
% OUTPUT:
% mu0 = ground-truth time in hypoglycemia on the entire dataset
% sigma2 = ground-truth variance of the bernoulli variable
% alpha = ground-truth value of correlation between consecutive dichotomized samples
% CGM_data = data
% INPUT:
% CGM_data = data
% dich_data = dichotomized version of data
% CGM_sampling = sampling time of CGM sensor (5 min for RBG dataset)
% show_figure = flag equal to 1 to plot autocorrelation and fit for all subjects

n_subj = size(CGM_data,1);

for idx_subj = 1:n_subj
    
    %Get CGM data and transform it to a timeseries to be fed into
    %AGATA
    glucose = CGM_data(idx_subj,starting_point:ending_point)'; %get glucose values
    time = datetime(2000,1,1,0,0,0):minutes(CGM_sampling):(datetime(2000,1,1,0,0,0)+minutes(CGM_sampling*length(glucose)-CGM_sampling)); %create a dummy time vector
    data = timetable(glucose,'VariableNames', {'glucose'}, 'RowTimes', time); %create the timetable

    perc_time_hypo(idx_subj) = timeInHypoglycemia(data); %use AGATA

end

CGM_data(perc_time_hypo<1,:) = [];
perc_time_hypo(perc_time_hypo<1) = [];
n_subj = size(CGM_data,1);

for idx_subj = 1:n_subj
    AC = autocorr(dich_data(idx_subj,:),'NumLags',20);
    [p_est,~]=WNLLS(AC);
    alpha(idx_subj) = p_est(1)*exp(-p_est(2));
    
    if show_figure == 1
        figure();
        plot([0:20],log(AC),'or','linewidth',1.2); 
        hold on; 
        plot([0:20],log((alpha(idx_subj)).^[0:20]),'g','linewidth',1.2);
        legend('Autocorrelation samples','WLLS weighting the first points more');
        title(['Fit of Autocorrelation - \alpha = ',num2str(alpha(idx_subj))]);
        xlabel('\tau'); ylabel('log (E[ x_k , x_k:+_\tau ])');
    end
end

mu0 = perc_time_hypo/100;
sigma2 = mu0.*(1-mu0);

end
