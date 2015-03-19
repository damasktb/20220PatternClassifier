close all;
clear all;

L = 15; % semi-width of interval
dx = 0.01; % distance between successive points
x = -L: dx : L; % sample points

mu = 3; % mean
sig = 4; % standard deviation
C = sig^2; % variance

g = exp( -0.5*(x-mu).*C^(-1).*(x-mu) ) / (sqrt(2*pi)*sqrt(C));

g0 = 1/ (sqrt(2*pi)*sqrt(C)); % value at x = mu, or 0 standard deviations
g1 = exp( -0.5 ) * g0; % value at 1 standard deviation
g2 = exp( -0.5*2^2 ) * g0; % value at 2 standard deviations
g3 = exp( -0.5*3^2 ) * g0; % value at 3 standard deviations

%%
s0 = sum( g.* dx ) % area under curve

i = abs(x) <= sig;
s1 = sum( g(i).*dx ) / s0
i = abs(x) <= 2*sig;
s2 = sum( g(i).*dx ) / s0
i = abs(x) <= 3*sig;
s3 = sum( g(i).*dx ) / s0

%% visualise

figure
hold on;
plot( x, g );
plot( [mu mu], [0 g0] );
plot( mu+[-sig sig], [g1 g1] );
plot( mu+2*[-sig sig], [g2 g2] );
plot( mu+3*[-sig sig], [g3 g3] );