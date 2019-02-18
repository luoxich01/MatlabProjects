%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Use Matlab to write a computer code which takes as inputs: • The initial stock price S0
%• The payoff function g(ST )
%• The interest rate r
%• The length of the period h
%• The up and down factors u and d
%• The number of periods T
%and which calculates the American option price as well as the composition of the replicating 
%portfolio at every node of the tree and also determines the optimal exercise dates.
%Apply your code to compute the initial value of an American put and an American
%call with strike K = 10 in a binomial model with r = 0.01, u = erh+0.15 h, d = √
%erh−0.15 h, h = 1/365, S0 = 10, and T = 250 periods.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

K=10;
r=0.01;
u=exp(r*h+0.2*sqrt(h));
d=exp(r*h-0.2*sqrt(h));
h=1/365;
S0=10;
T=250;
drift=exp(r*h);
n=T/h;
p=(exp(r*h)-d)/(u-d);

% price American call option
stkval=cell(n+1,n+1);    
optval=cell(n+1,n+1);  
stkval{1,1}=S0;
delta_ac=cell(n,n);
bond_ac=cell(n,n);

for i = 2:n+1
    stkval{i,1}=stkval{i-1,1}*u;
    for j = 2:i+1
        stkval{i,j}=stkval{i-1,j-1}*d;
    end
end

for j = 1:n+1
    optval{n+1,j}=payoff3(stkval{n+1,j},K);
end
    
for i = n:1
    for j =1:i
        optval{i,j}=(p*optval{i+1,j}+(1-p)*optval{i+1,j+1})/drift;
        optval{i,j}=max(optval{i,j},stkval{i,j}-K);
        delta_ac{i,j}=(optval{i+1,j}-optval{i+1,j+1})/(stkval{i,j}*(u-d));
        bond_ac{i,j}=exp(-r*h)*(optval{i+1,j+1}*u-optval{i+1,j}*d)/(u-d);
    end
end

% Price4 is the price of American call option
price4=optval{1,1};

% price American put option
stkval=cell(n+1,n+1);    
optval=cell(n+1,n+1);  
stkval{1,1}=S0;
delta_ap=cell(n,n);
bond_ap=cell(n,n);

for i = 2:n+1
    stkval{i,1}=stkval{i-1,1}*u;
    for j = 2:i+1
        stkval{i,j}=stkval{i-1,j-1}*d;
    end
end

for j = 1:n+1
    optval{n+1,j}=payoff4(stkval{n+1,j},K);
end
    
for i = n:1
    for j =1:i
        optval{i,j}=(p*optval{i+1,j}+(1-p)*optval{i+1,j+1})/drift;
        optval{i,j}=max(optval{i,j},K-stkval{i,j});
        delta_c{i,j}=(optval{i+1,j}-optval{i+1,j+1})/(stkval{i,j}*(u-d));
        bond_c{i,j}=exp(-r*h)*(optval{i+1,j+1}*u-optval{i+1,j}*d)/(u-d);
    end
end

% Price5 is the price of American put option
price5=optval{1,1};

% The payoff function for call option
function y=payoff3(ST,K)
y=max(ST-K,0);
end

% The payoff function for put option
function y=payoff4(ST,K)
y=max(K-ST,0);
end
