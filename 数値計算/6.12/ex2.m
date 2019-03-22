a = -2; b = 2;
x = linspace(a,b,9);            % 7 equidistant nodes
y = 1./(1+25*x.^2);                % function values at nodes
s = -50*x./(1+25*x.^2).^2;          % derivatives at nodes

xe = linspace(a,b,1000);         % evaluation points
ye = 1./(1+25*xe.^2);              % function values at xe

plot(x,y,'o',xe,ye,'k:')
title('1/(1+25*x^2)')
hold on

yherm = hermite(x,y,s,xe);      % pw cubic Hermite interpolation
maxerr_herm = max(abs(yherm-ye))

sa = s(1); sb = s(end);         % slopes at left and right endpoint
ycomp = spline(x,[sa,y,sb],xe); % complete spline
maxerr_complete = max(abs(ycomp-ye));

ynar = spline(x,y,xe);          % natural spline
maxerr_natural = max(abs(ynar-ye));

plot(xe,yherm,'b',xe,ycomp,'r',xe,ynar,'g')
legend('given points','f(x)','Hermite','complete spline','natural spline')
hold off

figure(2)
plot(xe,yherm-ye,'b',xe,ycomp-ye,'r',xe,ynar-ye,'g'); grid on
title('Errors')
legend('Hermite','complete spline','natural spline')

figure(3)
plot(x,y,'o',xe,ye,'k:')
title('1/(1+25*x^2)')
hold on
plot(xe,yherm,'b',xe,ycomp,'g')
legend('given points','f(x)','Hermite','natural spline')
hold off

figure(4)
plot(xe,yherm-ye,'b',xe,ycomp-ye,'r'); grid on
title('Errors')
legend('Hermite','natural spline')