%An Asian option is an option on the time average of the underlying asset. 
%Consider the case of an Asian call option with discrete arithmetic averaging. 
%An option with maturity of T years and strike K has the payoff
%􏰂 1 􏰄N 􏰃
%max N S(ti)−K,0 (2)
%i=1 where ti = i×h and h = T/N. 
%Furthermore, assume S(t0) = 200, r = 0.02, σ = 0.20, K = 220, T = 1, and N = 365. 
%For this exercise, reset the random number generator before each simulation run by randn(’seed’,0).
%a. Price the option by Monte Carlo simulation using 100,000 paths.
%b. State the associated 95 percent confidence interval of the option price.

% a
S0=200;
r=0.02;
sigma=0.2;
K=220;
T=1;
N=365;
h=T/N;
st=cell(100000,366);
st{1,1}=S0;
optval=cell(100000,1);
sum=0;

for i = 1:100000
    sum=0;
    for j = 2:366
        randn('seed',0);
        st{i,j}=exp(log(st{i,j-1})+(r-1/2*sigma^2)*h+sigma*randn(1,1)*sqrt(h));
        sum=sum+st{i,j};
    end
    optval{i,1}=max(sum/N-K,0);
end

% The price of Asian option is:
asianop=exp(-r*T)*sum(optval)/100000;

% b
% Standard Error
SEM = std(optval)/sqrt(length(optval));  
% T-Score
ts = tinv([0.025  0.975],length(optval)-1);      
CI = mean(optval) + ts*SEM; 
