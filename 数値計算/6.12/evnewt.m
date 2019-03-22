function p = evnewt(d,x,t)
p = d(1)*ones(size(t));
for i=2:length(d)
  p = p.*(t-x(i)) + d(i);
end
