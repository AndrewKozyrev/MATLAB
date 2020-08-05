%% Our noise
cd 'C:\Users\hitma\OneDrive\ROOT\Files\Job\Projects\MATLAB\CHAOS\IndexOfChaos';
clc, clear, format long
% Activate module
a = -0.75;      % parameter
b = -0.511;      % parameter
x1 = -0.2;       % initial conditions
x2 = 0.2;       % initial conditions
M = 10^5;       % number of elements left out for transient
N = 10^6;       % number of elements in a sequence
object = CCA(a, b, x1, x2, 13, N, M);
temp1 = '1010101010101010101010101010101010101010';
temp2 = '0101010101010101010101010101010101010101';
temp3 = '1100110011001100110011001100110011001100';
temp4 = '1111000011110000111100001111000011110000';
temp5 = '1111111100000000111111110000000011111111';
temp6 = '1111111111111111111100000000000000000000';
temp = [temp1; temp2; temp3; temp4; temp5; temp6];
tic
for i = 1:1:78
    k = ceil(i/13);
    [~, ~, cyp{i}] = object.encode(temp(k, :), i);
    out{i} = dec2bin(cyp{i});
end
end_time = toc
s = strcat(out{:});
seq = s - '0';

%% Test for Golomb's postulates
tic
test1 = TestChaos.Golomb(S)
toc
disp("done");


%% Chi-square Test
tic
test2 = TestChaos.chiSquare(S, 'plot')
toc
disp("done");

%% Spectral Analysis
tic
test3 = TestChaos.fourierTest(S)
toc