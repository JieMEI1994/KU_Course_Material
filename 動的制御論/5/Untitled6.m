% Min fuel for double integrator
% 16.323 Spring 2008
% Jonathan How
%
t_f = 1;
u_m = 5;
yd0 = 3;
y0 = 2;

c=1;
t=[0:.01:t_f];
alp=(1/2/u_m); % switching line
T_2=roots([-u_m/2 yd0 y0] + conv([-u_m yd0],[-2 t_f+yd0/u_m])-alp*conv([-u_m yd0],[-u_m yd0]));%
t_2=min(T_2);
yd2=-u_m*t_2+yd0;yd1=yd2;
t_1=t_f+yd1/u_m;
c_1=2/(t_1-t_2);c_2=c_1*t_1-1;
G=ss([0 1;0 0],[0 1]',eye(2),zeros(2,1));
arc1= [0:.001:t_2]'; 
arc2= [t_2:.001:t_1]';
arc3= [t_1:.001:t_f]'; 

[Y1,T1,X1]=lsim(G,-u_m*ones(length(arc1),1),arc1,[y0 yd0]'); %
[Y2,T2,X2]=lsim(G,0*ones(length(arc2),1),arc2,Y1(end,:)'); %
[Y3,T3,X3]=lsim(G,u_m*ones(length(arc3),1),arc3,Y2(end,:)'); %
plot(Y1(:,1),Y1(:,2),zzz,'Linewidth',2); hold on%
plot(Y2(:,1),Y2(:,2),zzz,'Linewidth',2); plot(Y3(:,1),Y3(:,2),zzz,'Linewidth',2);%
ylabel('dy/dt','Fontsize',18); xlabel('y(t)','Fontsize',12);%
text(-4,3,'y=-1/(2u_m)(dy/dt)^2','Fontsize',12)%
text(4,4,'-','Fontsize',18);text(-4,-4,'+','Fontsize',18);grid on;hold off
title(['t_f = ',mat2str(t_f)],'Fontsize',12)%
hold on;% plot the switching curves
kk=[0:.1:8]'; plot(-alp*kk.^2,kk,'k--');plot(alp*kk.^2,-kk,'k--');
hold off;axis([-4 4 -4 4]/4*6);
figure(2);%
p2=c_2-c_1*t;%
plot(t,p2,'Linewidth',4);%
hold on; plot([0 t_f],[c c],'k--','Linewidth',2);hold off; %
hold on; plot([0 t_f],-[c c],'k--','Linewidth',2);hold off; %
hold on; plot([t_1 t_1],[-2 2],'k:','Linewidth',3);hold off; %
text(t_1+.1,1.5,'t_1','Fontsize',12)%
hold on; plot([t_2 t_2],[-2 2],'k:','Linewidth',3);hold off; %
text(t_2+.1,-1.5,'t_2','Fontsize',12)%
title(['c = Åf,mat2str(c),Åf u_m = ',mat2str(u_m)],'Fontsize',12);%
ylabel('p_2(t)','Fontsize',12); xlabel('t','Fontsize',12);%
text(1,c+.1,'c','Fontsize',12);text(1,-c+.1,'-c','Fontsize',12)%
axis([0 t_f -3 3]);grid on; %
return

figure(1);clf
y0=2;yd0=3;t_f=5.8;u_m=1.5;zzz='-';minu;
figure(1);hold on
y0=2;yd0=3;t_f=16;u_m=1.5;zzz='k--';minu;
figure(1);hold on
y0=2;yd0=3;t_f=32;u_m=1.5;zzz='r:';minu;
figure(1);
axis([-6 6 -6 6])
legend('5.8','16','32')
print -f1 -dpng -r300 uopt1.png;
figure(1);clf
y0=2;yd0=2;t_f=8;u_m=1.5;zzz='-';minu
figure(1);hold on
y0=6;yd0=2;t_f=8;u_m=1.5;zzz='k--';minu
figure(1);hold on
y0=15.3;yd0=2;t_f=8;u_m=1.5;zzz='r:';minu
figure(1);axis([-2 25 -6 6])
print -f1 -dpng -r300 uopt2.png;