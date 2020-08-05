cd 'C:\Users\hitma\OneDrive\ROOT\Files\Job\Projects\MATLAB\CHAOS\CCA'
clear, clc

a   = -0.75;         % parameter
b   = -0.511;        % parameter
x1  = -0.2;          % initial conditions
x2  = 0.2;           % initial conditions
M   = 10^5;          % number of elements left out for transient
N   = 10^6;          % number of elements in a sequence

object = CCA(a, b, x1, x2, 13, N, M);

%%
object.displayPortrait('0.1');
object.drawBorders();

% this yields key 14725836
%% Encoding example
s = {
    '1010101010101010101010101010101010101010'; '0101010101010101010101010101010101010101';...
    '1100110011001100110011001100110011001100'; '1111000011110000111100001111000011110000';...
    '1111111100000000111111110000000011111111'; '1111111111111111111100000000000000000000'
    };

for i=1:78
    [c{i}, c_oct{i}, c_dec{i}] = object.cypher(s{ceil(i/13)}, i);
end
S = strcat(c{:}) - '0';
