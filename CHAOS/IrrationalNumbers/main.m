%% Our noise
cd 'C:\Users\hitma\OneDrive\ROOT\Files\Job\Projects\MATLAB\CHAOS\IrrationalNumbers';
clc, clear, format long
% variables
n = 100;
dig = 32;
tic
x = sym(2^sym(1/2)-1);
s = Dyadic.getBinary(x, n, 'approximate', dig)       % irrational numbers noise
cypher_time = toc