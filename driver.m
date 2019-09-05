%%  This script simulates discrete logistic map
%  x(n+1) = r*x(n)(1-x(n))

clc, clear, format long
% variables

r   = 4;
x_0 = rand(1, 2);
samplesize = 1000;
x_1   = logistic_map(r, x_0(1), 10001, 10^9);
x_2   = logistic_map(r, x_0(2), 10001, 10^9);

x1  = binary_logistic(x_1(1:samplesize), samplesize);
x2  = binary_logistic(x_2(1:samplesize), samplesize);
acf = autocorr(x1, samplesize - 1);
ccf = crosscorr(x1, x2, samplesize - 1);

clf
subplot(211)
autocorr(x1, samplesize - 1)
hold
subplot(212)
crosscorr(x1, x2, samplesize - 1)
%% writing data to a file

% Binary file
x_double = double(x);
filebin = 'Logistic_Map/chaos_digital.dat';
FID = fopen(filebin, 'w');
fwrite(FID, x_double, 'double');
fclose(FID);

% text file
x_txt = string(x);
filetxt = 'Logistic_Map/chaos_digital.txt';
fid = fopen(filetxt, 'w');
fprintf(fid, '%s\n', x_txt);
fclose(fid);

% Excel file
filexls = 'Logistic_Map/chaos_digital.xlsx';
T = table(x_double');
writetable(T, filexls, 'Sheet', 1, 'Range', 'A1');



%% read from binary file
FID = fopen(filebin, 'r');
A = fread(FID, 'double');
fclose(FID);