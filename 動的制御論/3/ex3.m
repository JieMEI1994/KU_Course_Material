% Problem 3
clear; % clear memory

% Time parameter
N = 1000; % sampling number
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

% Evaluation function
P1 = zeros(4,N);
P2 = zeros(4,N);
P3 = zeros(4,N);
P4 = zeros(4,N);

figure
for i = 1:4
    a = [1 1 1 1];
    for j = 1:N
        a(1,i) = j;
        Q = C'*diag([a(:,1),a(:,2)])*C;
        R = diag([a(:,3),a(:,4)]);
        % optimal regulator
        [K,S,E] = lqr(A,B,Q,R);
        % system
        system = ss(A-B*K, B, C, D);
        p = pole(system);
        P1(i,j) = p(1);
        P2(i,j) = p(2);
        P3(i,j) = p(3);
        P4(i,j) = p(4);
    end
end


% Figure
figure(1)
plot(real(P1(1,:)),imag(P1(1,:)), real(P2(1,:)),imag(P2(1,:)), real(P3(1,:)),imag(P3(1,:)), real(P4(1,:)),imag(P4(1,:)))
hold on
plot(real(P1(1,1)),imag(P1(1,1)),'ro',real(P2(1,1)),imag(P2(1,1)),'bo',real(P3(1,1)),imag(P3(1,1)),'go',real(P4(1,1)),imag(P4(1,1)),'yo')
xlabel('Real part')
ylabel('Imaginary part')
title('Change of a0')
grid on;
saveas(figure(1), 'Change of a0.jpg');

figure(2)
plot(real(P1(2,:)),imag(P1(2,:)),real(P2(2,:)),imag(P2(2,:)),real(P3(2,:)),imag(P3(2,:)),real(P4(2,:)),imag(P4(2,:)))
hold on
plot(real(P1(2,1)),imag(P1(2,1)),'ro',real(P2(2,1)),imag(P2(2,1)),'bo',real(P3(2,1)),imag(P3(2,1)),'go',real(P4(2,1)),imag(P4(2,1)),'yo')
xlabel('Real part')
ylabel('Imaginary part')
title('Change of a1')
saveas(figure(2), 'Change of a1.jpg');

figure(3)
plot(real(P1(3,:)),imag(P1(3,:)),real(P2(3,:)),imag(P2(3,:)),real(P3(3,:)),imag(P3(3,:)),real(P4(3,:)),imag(P4(3,:)))
hold on
plot(real(P1(3,1)),imag(P1(3,1)),'ro',real(P2(3,1)),imag(P2(3,1)),'bo',real(P3(3,1)),imag(P3(3,1)),'go',real(P4(3,1)),imag(P4(3,1)),'yo')
xlabel('Real part')
ylabel('Imaginary part')
title('Change of a2')
saveas(figure(3), 'Change of a2.jpg');

figure(4)
plot(real(P1(4,:)),imag(P1(4,:)),real(P2(4,:)),imag(P2(4,:)),real(P3(4,:)),imag(P3(4,:)),real(P4(4,:)),imag(P4(4,:)))
hold on
plot(real(P1(4,1)),imag(P1(4,1)),'ro',real(P2(4,1)),imag(P2(4,1)),'bo',real(P3(4,1)),imag(P3(4,1)),'go',real(P4(4,1)),imag(P4(4,1)),'yo')
xlabel('Real part')
ylabel('Imaginary part')
title('Change of a3')
saveas(figure(4), 'Change of a3.jpg');

Pole = [P1 P2 P3 P4];
save -ascii Problem3.dat Pole