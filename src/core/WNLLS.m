function [p_est,model] = WNLLS(data)
% Applies weighted non linear least squares method for maximum likelihood
% estimation of parameters
% OUTPUT:
% p_est = estimated parameters with maximum likelihood
% model = obtained model
% INPUT:
% data = data to fit

info.z = data;
info.t = [0:length(data)-1];

A = 1;
a = 0.65;
p = [A,a]';
pup = p*10;
pdown = p/10;

%Weight more the first data (correlation is the second data)
n = length(info.t);
pesi=normpdf([-n+1:n-1],0,5);
pesi=pesi(1:n);
pesinorm=pesi/norm(pesi,1);

info.w = pesinorm.*info.z;

options=optimset('TolFun',1e-7,'TolX',1e-7);

[p_est,RESNORM,RESIDUAL,EXITFLAG,OUTPUT,LAMBDA,J]=lsqnonlin('exp_corr',p,pdown,pup,options,info);

model = p_est(1)*exp(-p_est(2)*info.t);

end