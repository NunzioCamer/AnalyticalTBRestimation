function visual_evaluation(errstima,alpha,sigma2,type,xaxis)
% Evaluate and plot the results of the analysis
% OUTPUT:
% errstima = estimation error of time in hypoglycemia
% alpha = ground-truth value of correlation between consecutive samples
% sigma2 = ground-truth value of variance of bernoulli variable
% type = 'bernoulli' or 'gaussian' variables
% xaxis = x axis where plotting results (optional)

if nargin==4
    N = size(errstima,2);
    xaxis = [1:N];
    start = 1;
elseif nargin==5
    N = xaxis(end);
    start = N-length(xaxis)+1;
end
    
var_errstima = nanvar(errstima);
mean_errstima = nanmean(errstima);

if strcmp(type,'normal')==1
    v = sigma2/(1-alpha^2);
else
    v = sigma2;
end

theoretical_formula = @(N) (sqrt(v*[...
1./N + ...
2./N.*alpha/(1-alpha)+...
2./(N.^2).*alpha/(1-alpha)^2.*(alpha.^N-1)...
]));

%% Exponential plot
figure(); 
hold on;
plot([start:N],sqrt(var_errstima));
plot([start:N],sqrt(v./[start:N]));
plot([start:N],theoretical_formula([start:N])); legend('Sample','Theoretical indipendent','Theoretical correlated');
title([type,' distribution: \alpha = ',num2str(alpha),'  \sigma^2 = ',num2str(v)])
ylabel('Standard Deviation'); axis tight;

%% log-log plot
figure(); 
hold on;
plot(log([start:N]),log(sqrt(var_errstima)));
plot(log([start:N]), log(sqrt(v./[start:N]))); 
plot(log([start:N]),log(theoretical_formula([start:N]))); 
title([type,' distribution: \alpha = ',num2str(alpha),'  \sigma^2 = ',num2str(v)])
legend('Sample','Theoretical indipendent','Theoretical correlated');
ylabel('Standard Deviation'); axis tight;


%% Boxplot
figure();
hold on; 
boxplot(errstima(:,xaxis));

plot([1:1:length(xaxis)],sqrt((var_errstima(xaxis))),'b','linewidth',1.5);
p1=plot([1:1:length(xaxis)],-sqrt((var_errstima(xaxis))),'b','linewidth',1.5);
set(get(get(p1,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

p1=plot([1:1:length(xaxis)],mean_errstima(xaxis),'b','linewidth',1.5);
set(get(get(p1,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

plot([1:1:length(xaxis)],theoretical_formula(xaxis),'Color',[0.93,0.69,0.13],'linewidth',1.5);
p2=plot([1:1:length(xaxis)],-theoretical_formula(xaxis),'Color',[0.93,0.69,0.13],'linewidth',1.5);
set(get(get(p2,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

xticks([1:5:length(xaxis)])
tick = strsplit(num2str([xaxis(1:5:end)]));
xticklabels({tick{1:end}});
title([type,' distribution: Data boxplot vs estimated SD']);
ylabel('$$\hat{\sigma^2}$$','Interpreter','Latex')
xlabel('N');


legend('Sample \mu,SD','Theoretical formula');



end

