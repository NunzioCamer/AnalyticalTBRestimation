function plot_results(errstima,alpha,sigma2,wind_sample)
% Plot the results of the analysis performed on real-world data
% INPUT:
% errstima = estimation error of time in hypoglycemia
% alpha = ground-truth value of correlation between consecutive dichotomized samples
% sigma2 = ground-truth value of variance on bernoulli variables
% wind_sample = sample inside each window where the estimation error has been computed

N_days = size(errstima,2);
N_samples = N_days*wind_sample;

x_days = [1:1:N_days];
x_samples = x_days*wind_sample;

theoretical_formula = @(N, alpha, v) (sqrt(v*[...
    1./N + ...
    2./N.*alpha/(1-alpha)+...
    2./(N.^2).*alpha/(1-alpha)^2.*(alpha.^N-1)...
    ]));

variance = nanvar(errstima);

figure(); hold on;

boxplot(errstima,'position',x_days);

plot(x_days,sqrt(variance),'r','linewidth',2);
plot(x_days,theoretical_formula(x_samples,alpha,sigma2),'b--','linewidth',2);

plot(x_days,-sqrt(variance),'r','linewidth',2);
plot(x_days,-theoretical_formula(x_samples,alpha,sigma2),'b--','linewidth',2);

legend('Sample','Theoretical')

xlim([0,30]);
ylim([-0.15,0.35]);

end






