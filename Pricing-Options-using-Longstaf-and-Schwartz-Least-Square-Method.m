%Assume S0 = 200, r = 0.1, and σ = 0.3. Build a Matlab code to price an American put option with K = 220 and T = 1. 
%The code should take as inputs the number of steps N and the number of simulated paths. 
%For this exercise, reset the random number generator before each simulation run by randn(’seed’,0). 
%a. Price the option with N = 250 and 100,000 paths.
%b. Keep N = 250 steps and price the option when the number of paths takes the
%values 10, 100, 1,000, 10,000, and 100,000. Make a graph.
%c. Keep the number of paths at 100,000 and price the option when the number of
%steps N takes the values 3, 10, 100, 250, and 1,000. Make a graph.


% a
option1=payoff6(250,100000);

% b
option2=payoff6(250,10);
option3=payoff6(250,100);
option4=payoff6(250,1000);
option5=payoff6(250,10000);
option6=payoff6(250,100000);

x=[10,100,1000,10000,100000];
y=[option2,option3,option4,option5,option6];
plot(x,y);

% c
option7=payoff6(3,100000);
option8=payoff6(10,100000);
option9=payoff6(100,100000);
option10=payoff6(250,100000);
option11=payoff6(1000,100000);

x=[3,10,100,250,1000];
y=[option7,option8,option9,option10,option11];
plot(x,y);

% The American put option price fuction 
% using the Longstaff and Schwartz Least- Square Method
function y=payoff6(N,simN)
S0=200;
r=0.1;
sigma=0.3;
K=220;
T=1;
h=T/N;
st=cell(simN,N+1);
st{1,1}=S0;
EX=cell(simN,N);
Y=cell(simN,N);
disc=exp(-r*h);

for i = 1:simN
    for j = 2:(N+1)
        randn('seed',0);
        st{i,j}=exp(log(st{i,j-1})+(r-1/2*sigma^2)*h+sigma*randn(1,1)*sqrt(h));
    end
end

% determine the cash flow matrix
for j = N:-1:1
    for i = simN:-1:1
        EX{i,j}=max(K-st{i,j},0);
    end
end

for j = N-1:-1:1
    for i = simN:-1:1
        Y{i,j}=EX{i,j+1}*disc;
    end
    
    % do regression
    p=polyfit(st{simN,j},Y{simN,j},2);
    % compute expected continuation value
    ECV=polyval(p,st{simN,j});
    
    % compare EX and ECV
    for i = 1:simN
        if EX{i,j}>ECV{i,j}
            EX{i,j}=EX{i,j};
        else
            EX{i,j+1}=0;
        end
    end    
end

% discounted the cash flow back to zero
disval_t=cell(simN,1);

for i = 1:simN
    disval=0;
    for j = 1:N
        disval=disval+EX{i,j}*exp(-r*h*j);
    end
    disval_t{j,1}=disval;
end

% average all paths
y=mean(disval_t);
end
