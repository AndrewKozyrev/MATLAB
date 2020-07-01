%% Our noise
cd 'C:\Users\hitma\OneDrive\ROOT\Files\Job\Projects\MATLAB\CHAOS\IrrationalNumbers';
clear, format long
% variables
n = 1000000;
tic
x = sym(3^sym(1/2)-2^sym(1/2));
l = 4;
s = Dyadic.getBinary(x, n, 'approximate')       % irrational numbers noise
cypher_time = toc