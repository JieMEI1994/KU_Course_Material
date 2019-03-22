function d = divdiff(x,y)
% compute Newton form coefficients of interpolating polynomial
n = length(x);
d = y;
for k=1:n-1
for i=1:n-k
d(i) = (d(i+1)-d(i))/(x(i+k)-x(i));
end
end
function yt = evnewt(d,x,xt)
% evaluate Newton form of interpolating polynomial at points xt
yt = d(1)*ones(size(xt));
for i=2:length(d)
yt = yt.*(xt-x(i)) + d(i);
end
