% Jonathan How
% TPmain.m
%
b=0.1;
%alp=[.05 .1 1 10 20];
alp=logspace(-2,2,10);
t=[];
for alpha=alp
m=TPBVP(b,alpha);
t=[t;m(1,end)];
end
figure(1);clf
semilogx(alp,(1800*b./alp).^0.2,'-','Linewidth',2)
hold on;semilogx(alp,t,'rs');hold off
xlabel('\alpha','FontSize',12);ylabel('t_f','FontSize',12)
legend('Analytic','Numerical')
title('Comparison with b=0.1')
% code from opt1.m on the analytic solution
b=0.1;alpha=0.1;
m=TPBVP(b,alpha);
tf=(1800*b/alpha)^0.2;
c1=120*b/tf^3;
c2=60*b/tf^2;
u=(-c2+c1*m(1,:))/b;
A=[0 1;0 0];B=[0 1]';C=eye(2);D=zeros(2,1);G=ss(A,B,C,D);X0=[10 0]';
[y3,t3]=lsim(G,u,m(1,:),X0);
figure(2);clf
subplot(211)
plot(m(1,:),u,'g-','LineWidth',2);
xlabel('Time','FontSize',12);ylabel('u(t)','FontSize',12)
hold on;plot(m(1,:),m(6,:),'--');hold off
subplot(212)
plot(m(1,:),abs(u-m(6,:)),'-')
xlabel('Time','FontSize',12)
ylabel('u_{Analytic}(t)-U_{Numerical}','FontSize',12)
legend('Analytic','Numerical')

figure(3);clf
subplot(221)
plot(m(1,:),y3(:,1),'c-','LineWidth',2);
xlabel('Time','FontSize',12);ylabel('X(t)','FontSize',12)
hold on;plot(m(1,:),m([2],:),'k--');hold off
legend('Analytic','Numerical')
subplot(222)
plot(m(1,:),y3(:,2),'c-','LineWidth',2);
xlabel('Time','FontSize',12);ylabel('dX(t)/dt','FontSize',12)
hold on;plot(m(1,:),m([3],:),'k--');hold off
legend('Analytic','Numerical')
subplot(223)
plot(m(1,:),abs(y3(:,1)-m(2,:)'),'k-')
xlabel('Time','FontSize',12);ylabel('Error','FontSize',12)
subplot(224)
plot(m(1,:),abs(y3(:,2)-m(3,:)'),'k-')
xlabel('Time','FontSize',12);ylabel('Error','FontSize',12)
