% Min time fuel for double integrator
% 16.323 Spring 2008
% Jonathan How
figure(1);clf;%
if jcase==1;y0=2;yd0=3; b=.75;u_m=1.5;% baseline
elseif jcase==2;y0=2;yd0=3; b=2;u_m=1.5;% fuel exp
elseif jcase==3;y0=2;yd0=3; b=.1;u_m=1.5;% fuel cheap
elseif jcase==4;y0=2;yd0=3; b=0;u_m=1.5;% min time
elseif jcase==5;y0=-4;yd0=4; b=1;u_m=1.5;% min time
end
% Tf is unknown - put together the equations to solve for it
alp=(1/2/u_m+2*b); % switching line
% middle of 8--6: t_2 as a ftn of t_f
T2=[1/u_m (2*b+1/u_m)*yd0/u_m]/(2*b+2/u_m);%
% bottom of 8--7: quadratic for y(t_2) in terms of t_2
% converted into quad in t_f
T_f=roots(-u_m/2*conv(T2,T2)+yd0*[0 T2]+[0 0 y0] - ...
alp*conv(-u_m*T2+[0 yd0],-u_m*T2+[0 yd0]));%
t_f=max(T_f);t=[0:.01:t_f]'; %
c_1=(2*b+2/u_m)/(t_f-yd0/u_m);% key parameters for p(t)
c_2=c_1*t_f-(b+1/u_m);% key parameters for p(t)
t_1=t_f-1/(u_m*c_1); t_2=t_f-(2*b+1/u_m)/c_1;%switching times
G=ss([0 1;0 0],[0 1]',eye(2),zeros(2,1));
arc1=[0:.001:t_2]'; arc2=[t_2:.001:t_1]';arc3=[t_1:.001:t_f]'; %
if jcase==4;arc2=[t_2 t_2+1e-6]';end
[Y1,T1,X1]=lsim(G,-u_m*ones(length(arc1),1),arc1,[y0 yd0]'); %
[Y2,T2,X2]=lsim(G,0*ones(length(arc2),1),arc2,Y1(end,:)'); %
[Y3,T3,X3]=lsim(G,u_m*ones(length(arc3),1),arc3,Y2(end,:)'); %
plot(Y1(:,1),Y1(:,2),'Linewidth',2); hold on%
plot(Y2(:,1),Y2(:,2),'Linewidth',2); plot(Y3(:,1),Y3(:,2),'Linewidth',2);%
ylabel('dy/dt','Fontsize',18); xlabel('y(t)','Fontsize',12);%
text(-4,3,'y=-1/(2u_m)(dy/dt)^2','Fontsize',12)%
if jcase ~= 4; text(-5,0,'y=-(1/(2u_m)+2b)(dy/dt)^2','Fontsize',12);end
text(4,4,'-','Fontsize',18);text(-4,-4,'+','Fontsize',18);grid;hold off
title(['t_f = ',mat2str(t_f)],'Fontsize',12)%
hold on;% plot the switching curves
if jcase ~= 4;kk=[0:.1:5]'; plot(-alp*kk.^2,kk,'k--','Linewidth',2);plot(alp*kk.^2,-kk,'k--','Linewidth',2);end
kk=[0:.1:5]';plot(-(1/(2*u_m))*kk.^2,kk,'k--','Linewidth',2);plot((1/(2*u_m))*kk.^2,-kk,'k--','Linewidth',2);%
hold off;axis([-4 4 -4 4]/4*6);
figure(2);p2=c_2-c_1*t;%
plot(t,p2,'Linewidth',4);%
hold on; plot([0 max(t)],[b b],'k--','Linewidth',2);hold off; %
hold on; plot([0 max(t)],-[b b],'k--','Linewidth',2);hold off; %
hold on; plot([t_1 t_1],[-2 2],'k:','Linewidth',3);hold off; %
text(t_1+.1,1.5,'t_1','Fontsize',12)%
hold on; plot([t_2 t_2],[-2 2],'k:','Linewidth',3);hold off; %
text(t_2+.1,-1.5,'t_2','Fontsize',12)%
title(['b = ',mat2str(b),' u_m = ',mat2str(u_m)],'Fontsize',12);%
ylabel('p_2(t)','Fontsize',12); xlabel('t','Fontsize',12);%
text(1,b+.1,'b','Fontsize',12);text(1,-b+.1,'-b','Fontsize',12)%
axis([0 t_f -3 3]);grid on; %
%
if jcase==1
print -f1 -dpng -r300 fopt5a.png;print -f2 -dpng -r300 fopt5b.png;
elseif jcase==2
print -f1 -dpng -r300 fopt6a.png;print -f2 -dpng -r300 fopt6b.png;
elseif jcase==3
print -f1 -dpng -r300 fopt7a.png;print -f2 -dpng -r300 fopt7b.png;
elseif jcase==4
print -f1 -dpng -r300 fopt8a.png;print -f2 -dpng -r300 fopt8b.png;
end