%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Instructions:
%Use Matlab to write a computer code which takes as inputs: • The initial stock price S0
%• The payoff function F (ST )
%• The interest rate r
%• The length of the period h
%• The up and down factors u and d • The number of periods T
%and which calculates the European option price as well as the composition of the replicating portfolio at every node of the tree.
%a. Apply your code to compute the initial value of a straddle with T = 4, r = 0.02, √√
%  h=0.25,u=erh+0.2 h,d=erh−0.2 h,S0 =100,andstrikeK=90.
%b. Apply your code to compute the initial value of a straddle with T = 40, r = 0.02,
%√√
%h=0.025,u=erh+0.2 h,d=erh−0.2 h,S0 =100,andstrikeK=90.
%  c. Apply your code to compute the initial value of a binary call option with T = 4, √√
%r=0.02,h=0.25,u=erh+0.2 h,d=erh−0.2 h,S0 =100,andstrikeK=90.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1 Pricing European Options
% a
S0=100;
T=4;
r=0.02;
h=0.25;
u=exp(r*h+0.2*sqrt(h));
d=exp(r*h-0.2*sqrt(h));
K=90;
drift=exp(r*h);
n=T/h;
p=(exp(r*h)-d)/(u-d);

stkval=cell(n+1,n+1);    
optval=cell(n+1,n+1);  
stkval{1,1}=S0;
% delta is the share of stocks in the replicating portfolio
delta_a=cell(n,n);
% bond is the value of bonds in the replicating portfolio
bond_a=cell(n,n);

for i = 2:n+1
    stkval{i,1}=stkval{i-1,1}*u;
    for j = 2:i+1
        stkval{i,j}=stkval{i-1,j-1}*d;
    end
end

for j = 1:n+1
    optval{n+1,j}=payoff1(stkval{n+1,j},K);
end
    
for i = n:-1:1
    for j = 1:i
        optval{i,j}=(p*optval{i+1,j}+(1-p)*optval{i+1,j+1})/drift;
        delta_a{i,j}=(optval{i+1,j}-optval{i+1,j+1})/(stkval{i,j}*(u-d));
        bond_a{i,j}=exp(-r*h)*(optval{i+1,j+1}*u-optval{i+1,j}*d)/(u-d);
    end
end

% Price1 is the price of European option
price1=optval{1,1};

% b
S0=100;
T=40;
r=0.02;
h=0.025;
u=exp(r*h+0.2*sqrt(h));
d=exp(r*h-0.2*sqrt(h));
K=90;
drift=exp(r*h);
n=T/h;
p=(exp(r*h)-d)/(u-d);

stkval=cell(n+1,n+1);    
optval=cell(n+1,n+1);  
stkval{1,1}=S0;
delta_b=cell(n,n);
bond_b=cell(n,n);

for i = 2:n+1
    stkval{i,1}=stkval{i-1,1}*u;
    for j = 2:i+1
        stkval{i,j}=stkval{i-1,j-1}*d;
    end
end

for j = 1:n+1
    optval{n+1,j}=payoff1(stkval{n+1,j},K);
end
    
for i = n:1
    for j =1:i
        optval{i,j}=(p*optval{i+1,j}+(1-p)*optval{i+1,j+1})/drift;
        delta_b{i,j}=(optval{i+1,j}-optval{i+1,j+1})/(stkval{i,j}*(u-d));
        bond_b{i,j}=exp(-r*h)*(optval{i+1,j+1}*u-optval{i+1,j}*d)/(u-d);
    end
end

% Price2 is the price of European option
price2=optval{1,1};

% c
S0=100;
T=4;
r=0.02;
h=0.25;
u=exp(r*h+0.2*sqrt(h));
d=exp(r*h-0.2*sqrt(h));
K=90;
drift=exp(r*h);
n=T/h;
p=(exp(r*h)-d)/(u-d);

stkval=cell(n+1,n+1);    
optval=cell(n+1,n+1);  
stkval{1,1}=S0;
delta_c=cell(n,n);
bond_c=cell(n,n);

for i = 2:n+1
    stkval{i,1}=stkval{i-1,1}*u;
    for j = 2:i+1
        stkval{i,j}=stkval{i-1,j-1}*d;
    end
end

for j = 1:n+1
    optval{n+1,j}=payoff2(stkval{n+1,j},K);
end
    
for i = n:1
    for j =1:i
        optval{i,j}=(p*optval{i+1,j}+(1-p)*optval{i+1,j+1})/drift;
        delta_c{i,j}=(optval{i+1,j}-optval{i+1,j+1})/(stkval{i,j}*(u-d));
        bond_c{i,j}=exp(-r*h)*(optval{i+1,j+1}*u-optval{i+1,j}*d)/(u-d);
    end
end

% Price3 is the price of European option
price3=optval{1,1};




