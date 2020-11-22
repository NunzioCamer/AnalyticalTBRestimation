function [obj_fun] = exp_corr(par,info)
% exponential function for maximum likelihood estimation
% OUTPUT:
% obj_fun = objective function to minimize for ML estimation
% INPUT:
% par = contains the 2 parameters of the exponential
% info = structure containing time, data and weights

A=par(1);
a=par(2);
y=(A*exp(-a)).^info.t;
obj_fun=(info.z-y)./info.w;

end
