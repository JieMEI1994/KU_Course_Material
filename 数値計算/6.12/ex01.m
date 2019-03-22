f = @(x) 1./(1+25*x.^2);                          % define function f
a = -2; b = 2;                                    % endpoints of interval
n = 9;                                            % number of nodes for interpolation
xt = linspace(a,b,1000);                         % use these x values for plotting
yt = f(xt); 
xe = a + (0:n-1)*(b-a)/(n-1);                     % equidistant nodes, same as  xe = linspace(a,b,n)
ye = f(xe);                                       % find values of f at nodes xe
s = -50*x./(1+25*x.^2).^2;                        % derivatives at nodes


d1 = divdiff(xe,ye);                              % use divided difference algorithm to find coefficients d
pt1 = evnewt(d1,xe,xt);                           % evaluate interpolating polynomial at points xt
                                         
xc = (a+b)/2 + (b-a)/2*cos(pi/n*((1:n)-.5));      % Chebyshev nodes
yc = f(xc);                                       % find values of f at nodes xc

d2 = divdiff(xc,yc);                              % use divided difference algorithm to find coefficients d
pt2 = evnewt(d2,xc,xt);                           % evaluate interpolating polynomial at points xt

sa = s(1); sb = s(end);                           % slopes at left and right endpoint
ycomp = spline(xe,[sa,ye,sb],xt);                 % complete spline
maxerr_complete = max(abs(ycomp-yt));


figure(1)
plot(xe,ye,'o',xc,yc,'o',xt,yt,xt,pt2,xt,ycomp,'g');grid on
legend('Equidistant nodes','Chebyshev nodes','Given function','Chebyshev polynomial','natural spline')
title('1/(1+25*x^2)')
hold off

figure(2)
plot(xt,pt2-yt,'b',xt,ycomp-yt,'r'); grid on
title('Errors')
legend('Chebyshev polynomial','natural spline')



