% Problem 1
clear; % clear memory

n=4; % dim(state)
m=2; % dim(input)
N = 10000; % sampling number

x = zeros(N,n); % state vector
u = zeros(N,m); % input vector
y = zeros(N,m); % output vector

d = 0.1 * randn(1,N); % disturbance to system 
v = 0.1 * randn(m,N); % disturbance to output	

% Time parameter
initial_time = 0;
final_time = 300;
t = zeros(N,1); % time
dt = (final_time - initial_time)/N; % delta time

for i=0:N-1
    t(i+1,1)=i*dt;
end

%Global parameters
global A
global B
global G
global C
global U

% System parameters
Y_v = -0.12;
Y_deta_r = 3.13;
L_beta = -4.12;
L_p = -0.974;
L_r = 0.292;
L_deta_a = 0.31;
L_deta_r = 0.183;
N_beta = 1.62;
N_p = -0.0157;
N_r = -0.232;
N_deta_a = 0.0127;
N_deta_r = -0.922;

g = 9.8;
v_sound = 340.29;
U = 0.8 * v_sound; % speed of the plane


% System matrices
A = [Y_v     0     -1     g/U;
	 L_beta  L_p    L_r   0   ;
	 N_beta  N_p    N_r   0   ;
     0       1      0     0   ];
 
B = [0         Y_deta_r/U;
	 L_deta_a  L_deta_r   ;
	 N_deta_a  N_deta_r   ;
     0         0          ];
 
G = [ Y_deta_r/U;
	  L_deta_r   ;
	  N_deta_r   ;
      0          ]; 
 
C = [1 0 0 0;
     0 0 0 1];
 
D = 0;
 
 
% State System
system = ss(A,[B G],C,D);


% Controllability and Observability
Uc = ctrb(A,B);
Uo = obsv(A,C);
Kc = rank(Uc);
Ko = rank(Uo);
Xco = [Kc Ko];
save -ascii controllability.dat Uc
save -ascii observabillity.dat Uo
save -ascii rank.dat Xco

% Eigen vector and Eigen value
[vec, val] = eig(A);
save -ascii vector.dat vec
save -ascii value.dat val

% Simulation
x(1, :) = [1 0 0 1]; % initial state
y = lsim(system,[u d'],t,x(1,:));

for i=1:N-1
    
%runge-kutta 4th order
p1 = xdt(x(i,:)',u(i,:)',d(:,i));
p2 = xdt(x(i,:)'+dt/2*p1,u(i,:)',d(:,i));
p3 = xdt(x(i,:)'+dt/2*p2,u(i,:)',d(:,i));
p4 = xdt(x(i,:)'+dt+p3,u(i,:)',d(:,i));

x(i+1,:) = x(i,:)' + dt/6 * (p1 + p2*2 + p3*2 + p4);

end

% Figure
figure(1)
plot(t, x(:, 1))
xlabel('Time(s)');
ylabel('Angle of Sideslip(rad)');
title('Angle of Sideslip');
grid on;
saveas(figure(1), 'Angle of Sideslip.jpg');

figure(2)
plot(t, x(:, 2))
xlabel('Time(s)');
ylabel('Speed of Roll(rad/s)');
title('Speed of Roll');
grid on;
saveas(figure(2), 'Speed of Roll.jpg');

figure(3)
plot(t, x(:, 3))
xlabel('Time(s)');
ylabel('Speed of Yaw(rad/s)');
title('Speed of Yaw');
grid on;
saveas(figure(3), 'Speed of Yaw.jpg');

figure(4)
plot(t, x(:, 4))
xlabel('Time(s)');
ylabel('Angle of Bank(rad)');
title('Angle of Bank');
grid on;
saveas(figure(4), 'Angle of Bank.jpg');

X = [t x];
save -ascii Problem1.dat X
