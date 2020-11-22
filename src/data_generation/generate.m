function [data,errstima,sigma2,alpha,mu0] = generate(type,varargin)
%Generate data of a certain type
% OUTPUT:
% data = synthetic data 
% errstima = estimation error of TBR estimation
% sigma2 = ground-truth value of variance of bernoulli variable
% alpha = ground-truth value of correlation of consecutive samples
% mu0 = ground-truth value of TBR
% INPUT:
% type = 'Bernoulli' or 'normal'
% N = number of samples
% N_rip = number of repetitions
% mu0 = mean
% sigma2 = variance
% alpha = linked to the correlation factor
% P11 = in a Markov chain P to remain in 1
% P00 = in a Markov chain P to remain in 0

%% Parameters setting
%Default: no values
N = 1000;
N_rip = 100;
mu0 = NaN;
sigma2 = NaN;
alpha = NaN;
P00 = NaN;
P11 = NaN;

while ~isempty(varargin)
    switch (varargin{1})
        
        case 'N'
            N = varargin{2};
        case 'N_rip'
            N_rip = varargin{2};
        case 'mu0'
            mu0 = varargin{2};
        case 'sigma2'
            sigma2 = varargin{2};
        case 'alpha'
            alpha = varargin{2};
        case 'P00'
            P00 = varargin{2};
        case 'P11'
            P11 = varargin{2};
    end
    varargin(1:2) = [];
end
if isnan(sigma2)
    sigma2 = mu0*(1-mu0);
end


%% Sample generation

if strcmp(type,'normal')==1
    
    x(1) = sqrt((sigma2/(1-alpha^2))).*randn(1); 

    for i = 2:N
        x(i) = alpha*x(i-1) + sqrt(sigma2).*randn(1); %AR(1) Model
    end
    B = eye(N);
    for r = 2:N
            B(r,r-1) = -alpha;
    end

    E = sigma2*eye(N); %Covariance matrix of white noise driving the AR(1)
    E(1,1)=sigma2/(1-alpha^2); %To avoid transitory
    Sigma_data=inv(B)*E*inv(B'); %Covariance matrix of multivariate normal

    for idx_rip = 1:N_rip
        data(idx_rip,:) = mvnrnd(mu0.*ones(N,1),Sigma_data); %Multivariate normal
        disp(['%%%%%%%%%%   SAMPLE ',num2str(idx_rip),'   %%%%%%%%%%']);
        [s_mu(idx_rip),s_var(idx_rip),s_corr(idx_rip)] = evaluation(data(idx_rip,:),mu0,sigma2/(1-alpha^2),alpha);
    end
    
    disp(' ');
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    fprintf('Sample mean %g ,  mu0=%g \n', nanmean(s_mu),mu0)
    fprintf('Sample var %g ,  var=%g \n', nanmean(s_var),sigma2/(1-alpha^2))
    fprintf('Sample corr %g ,  corr=%g \n', nanmean(s_corr),alpha)
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%');    
    
    
    
elseif strcmp(type,'bernoulli')==1
    for idx_rip = 1:N_rip
        [data(idx_rip,:), p1, ~, ~] = generateCorrelatedBernulli(N,P11,P00);
        disp(['%%%%%%%%%%   SAMPLE ',num2str(idx_rip),'   %%%%%%%%%%']);
        [s_mu(idx_rip),s_var(idx_rip),s_corr(idx_rip)] = evaluation(data(idx_rip,:),mu0,sigma2,alpha);
    end
    
    disp(' ');
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    fprintf('Sample mean %g ,  mu0=%g \n', nanmean(s_mu),mu0)
    fprintf('Sample var %g ,  var=%g \n', nanmean(s_var),sigma2)
    fprintf('Sample corr %g ,  corr=%g \n', nanmean(s_corr),alpha)
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%'); 
end




%% Mean estimation error computation

for idx_rip=1:N_rip
    for idx_sample = 1:N
        meanvalue(idx_rip,idx_sample) = nanmean(data(idx_rip,1:idx_sample));
        errstima(idx_rip,idx_sample) = meanvalue(idx_rip,idx_sample)-mu0;
    end
end

end

