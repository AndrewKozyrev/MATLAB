%% Our noise
cd 'C:\Users\hitma\OneDrive\ROOT\Files\Job\Projects\MATLAB\CHAOS\IndexOfChaos';
clc, clear, format long
% variables
seq = readtable('trueRandom1000.xlsx').s;
s = '';
for i = 0:10:length(seq)-10
    temp = join(string(seq(i+1:i+10)), '');
    temp2 = bin2dec(temp);
    temp3 = dec2base(temp2, 32);
    s = strcat(s, temp3);
end

%% Test for Golomb's postulates
tic
test1 = TestChaos.Golomb(seq)
toc
disp("done");


%% Chi-square Test
tic
test2 = TestChaos.chiSquare(seq, 'plot')
toc
disp("done");

%% Spectral Analysis
tic
test3 = TestChaos.fourierTest(seq)
toc