function m = TPBVPlqr(p1,p2,p3)
global A B x0 Rxx Ruu Ptf
t_f=10;x0=[1 1]';
Rxx=p1;Ruu=p2;Ptf=p3;
solinit = bvpinit(linspace(0,t_f),@TPBVPlqrinit);
sol = bvp4c(@TPBVPlqrode,@TPBVPlqrbc,solinit);
time = sol.x;
state = sol.y([1 2],:);
adjoint = sol.y([3 4],:);
control = -inv(Ruu)*B'*sol.y([3 4],:);
m(1,:) = time;m([2 3],:) = state;m([4 5],:) = adjoint;m(6,:) = control;
%-------------------------------------------------------------------------?
function dydt=TPBVPlqrode(t,y)
global A B x0 Rxx Ruu Ptf
dydt=[ A -B/Ruu*B'; -Rxx -A']*y;
%-------------------------------------------------------------------------?
function res=TPBVPlqrbc(ya,yb)
global A B x0 Rxx Ruu Ptf
res=[ya(1) - x0(1);ya(2)-x0(2);yb(3:4)-Ptf*yb(1:2)];
%-------------------------------------------------------------------------?
function v=TPBVPlqrinit(t)
global A B x0 b alp
v=[x0;1;0];
return
% 16.323 Spring 2007
% Jonathan How
% redo LQR example on page 4-15 using numerical approaches
clear all;close all;
set(0, 'DefaultAxesFontSize', 14, 'DefaultAxesFontWeight','demi')
set(0, 'DefaultTextFontSize', 14, 'DefaultTextFontWeight','demi')
%
global A B
Ptf=[0 0;0 4];Rxx=[1 0;0 0];Ruu=1;A=[0 1;0 -1];B=[0 1]';
tf=10;dt=.01;time=[0:dt:tf];
m=TPBVPlqr(Rxx,Ruu,Ptf); % numerical result
% integrate the P backwards for LQR result
P=zeros(2,2,length(time));K=zeros(1,2,length(time));
Pcurr=Ptf;
for kk=0:length(time)-1
P(:,:,length(time)-kk)=Pcurr;
K(:,:,length(time)-kk)=inv(Ruu)*B'*Pcurr;
Pdot=-Pcurr*A-A'*Pcurr-Rxx+Pcurr*B*inv(Ruu)*B'*Pcurr;
Pcurr=Pcurr-dt*Pdot;
end
% simulate the state
x1=zeros(2,1,length(time));xcurr1=[1 1]';
for kk=1:length(time)-1
x1(:,:,kk)=xcurr1;
xdot1=(A-B*K(:,:,kk))*x1(:,:,kk);
xcurr1=xcurr1+xdot1*dt;
end
figure(3);clf
plot(time,squeeze(x1(1,1,:)),time,squeeze(x1(2,1,:)),'--','LineWidth',2),
xlabel('Time (sec)');ylabel('States');title('Dynamic Gains')
hold on;plot(m(1,:),m([2],:),'s',m(1,:),m([3],:),'o');hold off
legend('LQR x_1','LQR x_2','Num x_1','Num x_2')
print -dpng -r300 numreg2.png