function [x, p1, sigma_xk_xkplus1, trueAlpha]=generateCorrelatedBernulli(N,alpha,beta)
% Generate synthetic data matching the assumption of the theorem
% OUTPUT:
% x = generated synthetic data
% p1 = probability of hypoglycemia
% sigma_xk_xkplus1 = covariance of consecutive samples
% trueAlpha = correlation
% INPUT:
% N = number of samples to generate
% alpha = probability of remaining in hypoglycemia
% beta = probability of remaining out of hypoglycemia

p1= (1-beta)/(2-alpha-beta);
sigma_xk_xkplus1= alpha*p1- p1^2;

x(1)=double(rand<p1);
for ind=2:N

    if x(ind-1)==0
        x(ind)=double(rand<(1-beta)); % 1 with probability (1-beta)
    else
        x(ind)=double(rand<alpha);    % 1 with probability (alpha)
    end
end

trueSigma2=(p1*(1-p1));
trueAlpha=sigma_xk_xkplus1/trueSigma2;

end
