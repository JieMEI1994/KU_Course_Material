% Problem 2
clear; % clear memory

n=4; % dim(state)
m=2; % dim(input)
N = 10000; % sampling number

x = zeros(N,n); % state vector
u = zeros(N,m); % input vector
y = zeros(N,m); % output vector
x_estimation = zeros(N,n); %estimated state
y_filtered = zeros(N,m); %estimated output
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

% State System
system = ss(A,[B G],C,D);

%initial value
x(1,:) = [1 0 0 1];

% Kalman Gain and The solution of ARE
[L, P] = lqe(A, G, C, Q, R);
save -ascii L.dat L
save -ascii P.dat P

%Kalman Filter
[kalman,L,P,M] = kalman(system,Q,R);
kalman =(kalman(1:2,:));
y = lsim(system,[u d'],t,x(1,:)); % true response
y_measured = y+v'; % measured response
y_filtered = lsim(kalman,[u y_measured],t,x(1,:)); % filtered response

% Error
MeasErr = y-y_measured;
MeasErrCov = sum(MeasErr.*MeasErr)/length(MeasErr);
EstErr = y-y_filtered ;
EstErrCov = sum(EstErr.*EstErr)/length(EstErr);
Err = [MeasErrCov EstErrCov];
save -ascii Error.dat Err

% Figure
figure(1)
plot(t, y(:, 1), t, y_filtered(:, 1))
legend('True response','Filtered response')
xlabel('Time(s)');
ylabel('Angle of Sideslip(rad)');
title('Angle of Sideslip');
grid on;
saveas(figure(1), 'Angle of Sideslip with Kalman filter.jpg');

figure(2)
plot(t, y(:, 2), t, y_filtered(:, 2))
legend('True response','Filtered response')
xlabel('Time(s)');
ylabel('Angle of Bank(rad)');
title('Angle of Bank');
grid on;
saveas(figure(2), 'Angle of Bank with Kalman filter.jpg');

figure(3)
plot(t, y(:, 1)-y_measured(:, 1), t, y(:, 1)-y_filtered(:, 1))
legend('Measured response','Filtered response')
xlabel('Time(s)');
ylabel('Error');
title('Error in Angle of Sideslip');
grid on;
saveas(figure(3), 'Error in Angle of Sideslip.jpg');

figure(4)
plot(t, y(:, 2)-y_measured(:, 2), t, y(:, 2)-y_filtered(:, 2))
legend('Measured response','Filtered response')
xlabel('Time(s)');
ylabel('Error');
title('Error in Angle of Bank');
grid on;
saveas(figure(4), 'Error in Angle of Bank.jpg');

X = [t y y_measured y_filtered];
save -ascii Problem2.dat X
