
%A very simple way to incorporate dividends is to assume a constant dividend
%yield at the payment date. A feature of this model is that the tree for the ex-dividend
%uandd,whichnowaredefinedbyu=1/d=eσ√h,andp∗ =erh−d. u−d√
%  stock price St is recombining. Everything works out the same as before, except for
%  Consider a binomial model in which the ex-dividend price of the stock evolves according to
%St+1 = 􏰀1 − 1{t+1∈D}δ􏰁 Stξt+1 (1)
%where δ is a constant dividend yield, D ⊆ {1, ..., T } is the set of dividend dates, and ξt+1 ∈ {u, d}. 
%The variable 1{t+1∈D} takes the value of 1 if t + 1 is a dividend date and 0 otherwise. 
%An important feature of this model is that the tree for the ex-dividend stock price is recombining.
%Write a Matlab code which takes as inputs:
%• The payoff function g(S)
%• The nature of the derivative, i.e. European or American • The number of periods T
%• The interest rate r
%• The length of the period h
%• The up and down factors u and d
%• ThesetofdividenddatesD⊆{1,...,T}
%• The dividend yield δ
%• The initial ex-dividend stock price S0
%and which outputs the price as well as the composition of the replicating portfolio at every node of the tree 
%and which also determines the optimal exercise dates.'
%a. Apply your code to compute the initial prices of an American put and an American call 
%with strike K=10 when r=0.02,u=1/d=e0.2 h,h=1/365, S0 = 10, T = 200 periods, δ = 0.05, and D = {50,100,150}.
%b. Apply your code to compute the initial price of an American straddle with the same parameters as above. 
%If your calculations are correct, you should obtain Straddle < P ut + Call. Why?

% a 
K=10;
r=0.02;
h=1/365;
u=exp(0.2*sqrt(h));
d=1/u;
S0=10;
T=200;
div=0.05;
D=[50,100,150];
n=T/h;
% if derivative=1, then it is European option; if derivative=0, then it is
% American option
derivative=0;

% American put option
stkval=cell(n+1,n+1);    
optval=cell(n+1,n+1);  
stkval{1,1}=S0;
delta_ap_1=cell(n,n);
bond_ap_1=cell(n,n);

for i = 2:n+1
    t=(i-1)*h;
    if ismember(t,D)
        dividend=stkval{i-1,1}*div;
        stkval{i,1}=(stkval{i-1,1}-dividend)*u;
        for j = 2:i+1
            stkval{i,j}=(stkval{i-1,j-1}-dividend)*d;
        end
        else
            stkval{i,1}=stkval{i-1,1}*u;
            for j = 2:i+1
                stkval{i,j}=stkval{i-1,j-1}*d;
            end
    end
end

for j = 1:n+1
    optval{n+1,j}=payoff4(stkval{n+1,j},K);
end
    
for i = n:1
    for j =1:i
        optval{i,j}=(p*optval{i+1,j}+(1-p)*optval{i+1,j+1})/drift;
        if derivative==0
        optval{i,j}=max(optval{i,j},K-stkval{i,j});
        end
        delta_ap_1{i,j}=(optval{i+1,j}-optval{i+1,j+1})/(stkval{i,j}*(u-d));
        bond_ap_1{i,j}=exp(-r*h)*(optval{i+1,j+1}*u-optval{i+1,j}*d)/(u-d);
    end
end

% Price6 is the price of American put option
price6=optval{1,1};

% American call option
stkval=cell(n+1,n+1);    
optval=cell(n+1,n+1);  
stkval{1,1}=S0;
delta_ac_1=cell(n,n);
bond_ac_1=cell(n,n);

for i = 2:n+1
    t=(i-1)*h;
    if ismember(t,D)
        dividend=stkval{i-1,1}*div;
        stkval{i,1}=(stkval{i-1,1}-dividend)*u;
        for j = 2:i+1
            stkval{i,j}=(stkval{i-1,j-1}-dividend)*d;
        end
        else
            stkval{i,1}=stkval{i-1,1}*u;
            for j = 2:i+1
                stkval{i,j}=stkval{i-1,j-1}*d;
            end
    end
end

for j = 1:n+1
    optval{n+1,j}=payoff3(stkval{n+1,j},K);
end
    
for i = n:1
    for j =1:i
        optval{i,j}=(p*optval{i+1,j}+(1-p)*optval{i+1,j+1})/drift;
        if derivative==0
        optval{i,j}=max(optval{i,j},stkval{i,j}-K);
        end
        delta_ac_1{i,j}=(optval{i+1,j}-optval{i+1,j+1})/(stkval{i,j}*(u-d));
        bond_ac_1{i,j}=exp(-r*h)*(optval{i+1,j+1}*u-optval{i+1,j}*d)/(u-d);
    end
end

% Price7 is the price of American call option
price7=optval{1,1};

% b
stkval=cell(n+1,n+1);    
optval=cell(n+1,n+1);  
stkval{1,1}=S0;
delta_as=cell(n,n);
bond_as=cell(n,n);

for i = 2:n+1
    t=(i-1)*h;
    if ismember(t,D)
        dividend=stkval{i-1,1}*div;
        stkval{i,1}=(stkval{i-1,1}-dividend)*u;
        for j = 2:i+1
            stkval{i,j}=(stkval{i-1,j-1}-dividend)*d;
        end
        else
            stkval{i,1}=stkval{i-1,1}*u;
            for j = 2:i+1
                stkval{i,j}=stkval{i-1,j-1}*d;
            end
    end
end

for j = 1:n+1
    optval{n+1,j}=payoff1(stkval{n+1,j},K);
end
    
for i = n:1
    for j =1:i
        optval{i,j}=(p*optval{i+1,j}+(1-p)*optval{i+1,j+1})/drift;
        if derivative==0
        optval{i,j}=max(optval{i,j},K-stkval{i,j});
        end
        delta_as{i,j}=(optval{i+1,j}-optval{i+1,j+1})/(stkval{i,j}*(u-d));
        bond_as{i,j}=exp(-r*h)*(optval{i+1,j+1}*u-optval{i+1,j}*d)/(u-d);
    end
end

% Price8 is the price of American call option
price8=optval{1,1};

