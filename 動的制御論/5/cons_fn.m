%% Constraint function

function [C,Ceq]=cons_fn(X_opt)

N = (length(X_opt)-1)/3;
N_st = 2; 
t_f = X_opt(1);
x = X_opt(N+2:end);
u = X_opt(2:N+1);
x = reshape(x,N,N_st);
t = linspace(0,1,N)'*t_f;
dt = t(2) - t(1);

tc = linspace (t(1)+dt/2,t(end)-dt/2,N-1);

xdot = innerFunc(t,x,u);
xll = x(1:end-1,:);
xrr = x(2:end,:);
xdotll = xdot(1:end-1,:);
xdotrr = xdot(2:end,:);
ull = u(1:end-1,:);
urr = u(2:end,:);

xc = .5*(xll+xrr)+ dt/8*(xdotll-xdotrr);
uc = (ull+urr)/2;
xdotc = innerFunc(tc,xc,uc);

Ceq = (xll-xrr)+dt/6*(xdotll +4*xdotc +xdotrr );
Ceq =  Ceq(:);

Ceq = [Ceq ;
    x(1,1)-10 ;
    x(end,1);
    x(1,2)
    x(end,2);
    ];
C = [];


%% Cost function

function [cost,grad]= objfun(X_opt)
N = (length(X_opt)-1)/3;
t_f = X_opt(1);
cost = t_f;
grad = zeros(size(X_opt));
grad(1) = 1;