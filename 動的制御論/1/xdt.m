function x = xdt(x,u,d)

%Global parameters
global A
global B
global G

x = A*x + B*u + G*d;