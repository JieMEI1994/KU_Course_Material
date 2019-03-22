% Problem 4
clear; % clear memory

n=4; % dim(state)
m=2; % dim(input)
N = 10000; % sampling number

x = zeros(N,n); % state vector
u = zeros(N,m); % input vector
y = zeros(N,m); % output vector
x_estimation = zeros(N,n); %estimated state
y_estimated = zeros(N,m); %estimated output
y_measured = zeros(N,m); %observed output

Q = 1; % Var. of process niose
R = eye(2); % Var. of measurement niose

d = sqrt(Q)*randn(1,N); % disturbance to system 
v = sqrt(R)*randn(m,N); % disturbance to output	

% Time parameter
initial_time = 0;
final_time = 300;
t = zeros(N,1); % time
dt = (final_time - initial_time)/N; % delta time

for i=0:N-1
    t(i+1,1)=i*dt;
end


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


% System matrice
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

% Initial value
x(1,:) = [1 0 0 1];
% Convergence value
y_final = [0;-1];

% Weighting matrix
Q_K = C'*diag([10,20])*C;
R_K = diag([1,1]);

[K,S,E] = lqr(A,B,Q_K,R_K);
save -ascii optimal_gain.dat K
save -ascii closedloop_eigenvalue.dat E

% System
A_cl = A-B*K;
system = ss(A_cl,[B G],C,D);

u = -inv((C/A_cl)*B)*y_final;
u1 = zeros(N,1);
u2 = zeros(N,1);
u1(:,1) = u(1,1);
u2(:,1) = u(2,1);


% Kalman filter
[kest,L,P] = kalman(system,Q,R,0);
kest = kest(1:2,:);

% Observation and Estimation
y = lsim(system,[u1 u2 d'],t,x(1,:));
y_measured = y+v';
y_estimated = lsim(kest,[u1 u2 y_measured],t,x(1,:));

% Error
MeasErr = y-y_measured;
MeasErrCov = sum(MeasErr.*MeasErr)/length(MeasErr);
EstErr = y-y_estimated;
EstErrCov = sum(EstErr.*EstErr)/length(EstErr);
Err = [MeasErrCov EstErrCov];
save -ascii Error.dat Err

% Figure
figure(1)
plot(t, y(:, 1), t, y_estimated(:, 1))
legend('True responce','Estimated responce')
xlabel('Time(s)');
ylabel('Angle of Sideslip(rad)');
title('Angle of Sideslip with Optimal regulator');
grid on;
saveas(figure(1), 'Angle of Sideslip with Optimal regulator.jpg');

figure(2)
plot(t, y(:, 2), t, y_estimated(:, 2))
legend('True responce','Estimated responce')
xlabel('Time(s)');
ylabel('Angle of Bank(rad)');
title('Angle of Bank with Optimal regulator');
grid on;
saveas(figure(2), 'Angle of Bank with Optimal regulator.jpg');

figure(3)
plot(t, y(:, 1)-y_measured(:, 1), t, y(:, 1)-y_estimated(:, 1))
legend('True responce','Estimated responce')
xlabel('Time(s)');
ylabel('Error in Angle of Sideslip');
title('Error in Angle of Sideslip');
grid on;
saveas(figure(3), 'Error in Angle of Sideslip.jpg');

figure(4)
plot(t, y(:, 2)-y_measured(:, 2), t, y(:, 2)-y_estimated(:, 2))
legend('True responce','Estimated responce')
xlabel('Time(s)');
ylabel('Error in Angle of Bank');
title('Error in Angle of Bank');
grid on;
saveas(figure(4), 'Error in Angle of Bank.jpg');

X = [t y y_measured y_estimated];
save -ascii Regulator.dat X
