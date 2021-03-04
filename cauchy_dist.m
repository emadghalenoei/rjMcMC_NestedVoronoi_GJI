function x = cauchy_dist(x0,b,givensize,lower,upper,preference)
n = givensize(1);
m = givensize(2);
%while min(x-lower,[],'all')<0 || max(x-upper,[],'all')>0
x = x0+b*tan(pi*(rand(n,m)-0.5));

%%% this is the 1st order “mirroring”
% x (x<lower) = 2*lower - x; 
% x (x>upper) = 2*upper - x;

x (x<lower) = preference;
x (x>upper) = preference;
end