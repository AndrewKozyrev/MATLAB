cd 'C:\Users\hitma\OneDrive\ROOT\Files\Job\Projects\MATLAB\CHAOS\IndexOfChaos';

%%
clc, clear, format long
fid = fopen("C:\Users\hitma\OneDrive\ROOT\Files\Job\Projects\MATLAB\CHAOS\IndexOfChaos\trueRandom1000.txt", 'r');
s = fscanf(fid,'%s');
fclose(fid);

%% Test for Golomb's postulates
tic
test1 = TestChaos.Golomb(s)
toc
disp("done");


%% Chi-square Test
tic
test2 = TestChaos.chiSquare(s, 1, 0.05)
toc
disp("done");

%% Spectral Analysis
tic
test3 = TestChaos.fourierTest(s)
toc

