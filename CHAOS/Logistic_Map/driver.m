%%  This script simulates discrete logistic map
%  x(n+1) = r*x(n)(1-x(n))

cd 'C:\Users\hitma\OneDrive\ROOT\Files\Job\Projects\MATLAB\CHAOS\Logistic_Map'
clc, clear, format long
% variables

mu      = 3.831874055283316;            %cipher parameter
mu_0    = 2.5;          %transit parameter
M       = 0;            %length of transit process
n       = 10^3;         %length of final sequence

object = LogisticMap(mu_0, mu, M);



%%
tic
x0 = 0.45;
x1 = 0.55;
d0 = abs(x1 - x0);
s1 = object.getSequence(n, x0);
s2 = object.getSequence(n, x1);
d1 = abs(s2 - s1);
toc