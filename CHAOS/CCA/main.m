a = -0.78;      % parameter
b = -0.55;      % parameter
x1 = -0.2;       % initial conditions
x2 = 0.2;       % initial conditions
M = 10^7;       % number of elements left out for transient
N = 10^8;       % number of elements in a sequence

object = CCA(a, b, x1, x2, 8, N, M);

object.displayPortrait();
object.drawBorders();
zones = object.groupZones();

% 1 -> 1           1 -> 1
% 2 -> 4           2 -> 4
% 3 -> 7           3 -> 7
% 4 -> 2           4 -> 2
% 5 -> 5           5 -> 5
% 6 -> 8           6 -> 8
% 7 -> 3           7 -> 3
% 8 -> 6           8 -> 6

% this yields key 14725836