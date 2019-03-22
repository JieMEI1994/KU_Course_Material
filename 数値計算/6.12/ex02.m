%  Integral
clear; clc; 
f = @(x) exp(x);
a = 0; 
b = 2;
k = 8;
m = zeros(1,k);
t = zeros(1,k);
s = zeros(1,k);
c = zeros(1,k);

me = zeros(1,k);
te = zeros(1,k);
se = zeros(1,k);
ce = zeros(1,k);

for n=1:k
%n = k;
h = (b-a)/n;

X = a : h : b;
Y = f(X);

%M
Mn = 0;
for k = 1:n
 Mn = Mn + f(a+k*h-h/2);
end
Mn = h*Mn;
Me = ((h*h)/24) * (b-a) * Y(2);
%Me =  6.389056098930650227230427460575007813180315570551847324087 -Mn;
fprintf('M:%.12f error= %.2e\n', Mn, Me);
m(n) = Mn;
me(n) = Me;

% T
Tn = 0;
for k = 1:n-1
 Tn = Tn + f(a+k*h);
end
Tn = h*(Tn+(f(a)+f(b)/2));
Te = ((h*h)/12) * (b-a) * Y(2);
%Te =  6.389056098930650227230427460575007813180315570551847324087 -Tn;
fprintf('T:%.12f error= %.2e\n', Tn, Te );
t(n) = Tn;
te(n) = Te;

% S
Sn1 = 0;
for k = 1:n-1
 Sn1 = Sn1 + f(a+k*h);
end
Sn2 = 0;
for k = 1:n
 Sn2 = Sn2 + f(a+k*h-h/2);
end
Sn = h*(4*Sn2+2*Sn1+f(a)+f(b))/6;
Se = ((h^4)/2880 )* (b-a) * Y(2);
%Se =  6.389056098930650227230427460575007813180315570551847324087 -Sn;
fprintf('S:%.12f error= %.2e\n', Sn, Se);
s(n) = Sn;
se(n) = Se;

%C
[x,w] = lgwt(n,0,2);   
Cn = sum(w.*f(x));
Ce = 6.389056098930650227230427460575007813180315570551847324087-Cn; 
fprintf('C:%.12f error= %.2e\n', Cn, Ce);
c(n) = Cn;

end

figure(1)
plot(m,'-b','linewidth',1);
title('Midpoint rule');
grid on
figure(2)
plot(t,'-b','linewidth',1);
title('Trapezoidal rule');
grid on
figure(3)
plot(s,'-b','linewidth',1);
title('Simpson rule');
grid on
figure(4)
plot(me,'-b','linewidth',1);
title('Midpoint error');
grid on
figure(5)
plot(te,'-b','linewidth',1);
title('Trapezoidal error');
grid on
figure(6)
plot(se,'-b','linewidth',1);
title('Simpson error');
grid on

