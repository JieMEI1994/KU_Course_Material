function [ f ] = fun( x0, ns, ts, ws )

% Options for ODE solver
optODE = odeset( 'RelTol', 1e-8, 'AbsTol', 1e-8 );

% Forward state integration
z0 = [x0];
for ks = 1:ns
[tspan,zs] = ode15s( @(t,x)state(t,x,ws,ks), [ts(ks),ts(ks+1)], z0, optODE );
z0 = zs(end,:)';
end
% Functions
 f = zs(end,:)';

end
