function bangbangdetctrl05fig1
% Fig. A.4 Book Illustration for solution of Bang-Bang Control (3/2007)
%   Problem Example in Deterministic Optimal Control Chapter.
%   Application is a leaky reservoir with linear state dynamics: 
%       \dot{X}(t) = -a X(t)+U(t),   X(0) = x_0,
%   integral and point constraints,
%       \int_0^{t_f}U(t)dt = K >0, 0\leq U(t)\leq M, K\leq M t_f,
%   and running cost:
%       J[X]=\int_0^{t_f} X(t) dt
%   Technique is to make integral constraint into a new state,
%       X_2(t) = U(t), X_2(0) = 0, X_2(t_f) = K, so X_1(t) = X(t).
clc % clear variables, but must come before globals, 
    %    else clears globals too.
clf % clear figures
fprintf('\nfunction bangbangdetctrl05fig1 OutPut:');
%%% Initialize input:
N = 100; t0 = 0; tf = 2.0; dt = (tf-t0)/N;% Set time grid parameters.
a = 0.6; M = 2; K = 2.4; x0 = 1.0; % set constant parameters:
% get optimal control, optimal state and optimal multiplier sum:
t = 0:dt:tf; % time grid;
ts = K/M; % switch time for U* = M to U* = 0; 
fprintf('\nSwitch time = %f',ts);
nt = size(t,2);
x = x0*exp(-a*t); C2 = -(1-exp(-a*(tf-ts)))/a; expf = exp(-a*tf);
y = exp(a*t); ys = exp(a*ts); Mda = M/a;
lam1 = (1/a)*(1-expf*y); lamsum = C2+lam1;
u = zeros(nt);
for i=1:nt 
    if t(i)<=ts 
        u(i) = M;
        x(i) = x(i)+Mda*(1-1/y(i));
    else
        u(i) = 0;
        x(i) = x(i)+Mda*(ys-1)/y(i);
    end
end
% Begin Plot:
nfig = 1;
scrsize = get(0,'ScreenSize');
ss = [3.0,2.8,2.6,2.4,2.2,2.0];
fprintf('\n\nFigure(%i):  Bang-Bang Control Problem Example\n',nfig)
figure(nfig)
plot(t,u,'k-.',t,x,'k--',t,lamsum,'k:',t,zeros(size(t)),'k-' ...
    ,'LineWidth',4);
title('Bang-Bang Control Example'...
    ,'Fontsize',44,'FontWeight','Bold');
ylabel('U^*,  X^*,  \lambda_1^*+\lambda_2^*'...
    ,'Fontsize',44,'FontWeight','Bold');
xlabel('t, Time'...
    ,'Fontsize',44,'FontWeight','Bold');
text(ts,-0.15,'t_s','Fontsize',36,'FontWeight','Bold');
hlegend=legend('U^*(t), Control',...
    'X^*(t), State','\lambda_1*+\lambda_2*','Location','Best');
set(hlegend,'Fontsize',36,'FontWeight','Bold');
set(gca,'Fontsize',36,'FontWeight','Bold','linewidth',3);
set(gcf,'Color','White','Position' ...
    ,[scrsize(3)/ss(nfig) 70 scrsize(3)*0.60 scrsize(4)*0.80]);
%%%%
% End  bangbangdetctrl05fig1