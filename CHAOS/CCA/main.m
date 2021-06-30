cd 'C:\Users\hitma\OneDrive\ROOT\Files\Job\Projects\MATLAB\CHAOS\CCA'
clear, clc

a   = -0.75;         % parameter
b   = -0.511;        % parameter
x1  = -0.2;          % initial conditions
x2  = 0.2;           % initial conditions
M   = 1000;          % number of elements left out for transient
N   = 10^6;          % number of elements in a sequence

object = CCA(a, b, x1, x2, 13, N, M);

%%
object.displayPortrait('0.1');
object.drawBorders();

%% Encoding example
