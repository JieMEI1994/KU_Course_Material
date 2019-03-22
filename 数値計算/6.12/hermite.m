function output = hermite(x,y,s,xx)
output=[];
n=length(x);
if n<2, error('There should be at least two data points.'), end

if any(diff(x)<0), [x,ind]=sort(x); else, ind=1:n; end

x=x(:); dx = diff(x);
if all(dx)==0, error('The data abscissae should be distinct.'), end

[yd,yn] = size(y); 

if yn==1, yn=yd; y=reshape(y,1,yn); s=reshape(s,1,yn); yd=1; end

yi=y(:,ind).';s=s(:,ind).'; dd = ones(1,yd);
dx = diff(x); divdif = diff(yi)./dx(:,dd);

% convert to pp form
c4=(s(1:n-1,:)+s(2:n,:)-2*divdif(1:n-1,:))./dx(:,dd);
c3=(divdif(1:n-1,:)-s(1:n-1,:))./dx(:,dd) - c4;
pp=mkpp(x.',...
  reshape([(c4./dx(:,dd)).' c3.' s(1:n-1,:).' yi(1:n-1,:).'],(n-1)*yd,4),yd);
if nargin==3
   output=pp;
else
   output=ppval(pp,xx);
end