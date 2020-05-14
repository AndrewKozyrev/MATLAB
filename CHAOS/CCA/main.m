cd 'C:\Users\hitma\OneDrive\ROOT\Files\Job\Projects\MATLAB\CHAOS\CCA'

a = -0.75;      % parameter
b = -0.55;      % parameter
x1 = -0.2;       % initial conditions
x2 = 0.2;       % initial conditions
M = 0;       % number of elements left out for transient
N = 10^6;       % number of elements in a sequence

object = CCA(a, b, x1, x2, 8, N, M);

%%
object.displayPortrait(5, 8, 3, 6, 1, 4, 7, 2);
object.drawBorders(5, 8, 3, 6, 1, 4, 7, 2);

%%
% 1 -> 4           0 -> 5
% 2 -> 7           1 -> 8
% 3 -> 2           2 -> 3
% 4 -> 5           3 -> 6
% 5 -> 0           4 -> 1
% 6 -> 3           5 -> 4
% 7 -> 6           6 -> 7
% 8 -> 1           7 -> 2

% 58361472
% this yields key 14725836


%% 7 -> 8 -> 1 -> 2 -> 3 -> 4 -> 
p = [object.x1 object.x2];
z = object.identify(p);
[p2(1), p2(2)] = object.transient(5, false);
z2 = object.identify(p2);