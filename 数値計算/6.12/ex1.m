f = @(x) 1./(1+25*x.^2);                             % define function f
a = -2; b = 2;                                    % endpoints of interval
n = 9;                                            % number of nodes for interpolation
xt = linspace(-2,2,1000);                         % use these x values for plotting

xe = a + (0:n-1)*(b-a)/(n-1);                     % equidistant nodes, same as  xe = linspace(a,b,n)
ye = f(xe);                                       % find values of f at nodes xe


d1 = divdiff(xe,ye);                              % use divided difference algorithm to find coefficients d
pt1 = evnewt(d1,xe,xt);                           % evaluate interpolating polynomial at points xt
                                         
xc = (a+b)/2 + (b-a)/2*cos(pi/n*((1:n)-.5));      % Chebyshev nodes
yc = f(xc);                                       % find values of f at nodes xc

d2 = divdiff(xc,yc);                              % use divided difference algorithm to find coefficients d
pt2 = evnewt(d2,xc,xt);                           % evaluate interpolating polynomial at points xt


figure(1)                                         % plot function f and interpolating polynomial
plot(xt,f(xt),xt,pt1,xe,ye,'o');grid on; 
title('Equidistant nodes');
figure(2)
plot(xt,f(xt),xt,pt2,xc,yc,'o');grid on;
title('Chebyshev nodes');


ye = ones(size(xt));           % equidistant nodes: evaluate (x-x_1)...(x-x_n) for xt values
for j=1:n
  ye = ye.*(xt-xe(j));
end

yc = ones(size(xt));           % Chebyshev nodes: evaluate (x-x_1)...(x-x_n) for xt values
for j=1:n
  yc = yc.*(xt-xc(j));
end
figure(3)
plot(xt,ye,xt,yc); hold on     % plot node polynomials
plot(xe,zeros(1,n),'bo',xc,zeros(1,n),'ro') ; hold off  % mark nodes with 'o'
grid on;
title('Node polynomial \omega(x)')
legend('Equidistant nodes','Chebyshev nodes')