%
% Simple opt example showing impact of weight on t_f
% 16.323 Spring 2008
% Jonathan How
% opt1.m
%
clear all;
close all;
set(0, 'DefaultAxesFontSize', 14, 'DefaultAxesFontWeight','demi')
set(0, 'DefaultTextFontSize', 14, 'DefaultTextFontWeight','demi')
%
A=[0 1;0 0];B=[0 1]';C=eye(2);D=zeros(2,1);
G=ss(A,B,C,D);
X0=[10 0]';
b=0.1;
alp=1;
tf=(1800*b/alp)^0.2;
c1=120*b/tf^3;
c2=60*b/tf^2;
time=[0:1e-2:tf];
u=(-c2+c1*time)/b;
[y1,t1]=lsim(G,u,time,X0);

figure(1);
plot(time,u,'k-','LineWidth',2);hold on
alp=10;
tf=(1800*b/alp)^0.2;
c1=120*b/tf^3;
c2=60*b/tf^2;
time=[0:1e-2:tf];
u=(-c2+c1*time)/b;
[y2,t2]=lsim(G,u,time,X0);
plot(time,u,'b--','LineWidth',2);
alp=0.10;
tf=(1800*b/alp)^0.2;
c1=120*b/tf^3;
c2=60*b/tf^2;
time=[0:1e-2:tf];
u=(-c2+c1*time)/b;
[y3,t3]=lsim(G,u,time,X0);
plot(time,u,'g-.','LineWidth',2);hold off
legend('\alpha=1','\alpha=10','\alpha=0.1')
xlabel('Time (sec)')
ylabel('u(t)')
title(['b= ',num2str(b)])
figure(2);
plot(t1,y1(:,1),'k-','LineWidth',2);
hold on
plot(t2,y2(:,1),'b--','LineWidth',2);
plot(t3,y3(:,1),'g-.','LineWidth',2);
hold off
legend('\alpha=1','\alpha=10','\alpha=0.1')
xlabel('Time (sec)')
ylabel('y(t)')
title(['b= ',num2str(b)])
print -dpng -r300 -f1 opt11.png
print -dpng -r300 -f2 opt12.png