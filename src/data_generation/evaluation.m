function [sample_mean,sample_var,sample_corr] = evaluation(x,p1,sigma2,alpha)
% Compare actual and sample values
% OUTPUT:
% sample_mean = mean computed over generated samples
% sample_var = variance computed over generated samples
% sample_corr = correlation computed over generated samples
% INPUT:
% x = current repetition of bernoulli process
% p1 = actual probability of being in hypoglycemia
% sigma2 = actual variance of bernoulli variables
% alpha = actual correlation of bernoulli variables

%% Check mean
sample_mean = mean(x);
fprintf('Sample mean %g ,  p1=%g \n', sample_mean,p1)

%% Check Variance
var_teo=sigma2;
sample_var = var(x);
fprintf('Sample var %g ,  var=%g \n', sample_var,var_teo)


%% Check self-covariance        
x_kmux_k1mu=((x(1:end-1)-mean(x)).*(x(2:end)-mean(x)));
sample_cov_1= 1/length(x_kmux_k1mu)*sum(x_kmux_k1mu);


%% Check correlation   
% teorethical
corr_teo= alpha;
sample_corr = sample_cov_1/var(x);

% from sampled estimate
fprintf('Sample corr %g ,  corr=%g \n', sample_corr,corr_teo)

end

