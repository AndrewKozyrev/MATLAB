%%  This script simulates discrete logistic map
%  x(n+1) = r*x(n)(1-x(n))

clc, clear, format long
% variables

mu      = 3.9999;   %cipher parameter
mu_0    = 2.1;      %transit parameter
M       = 10^6;        %length of transit process
N       = 10^5;         %length of final sequence

%% Side A: Coding
information = randi([0 1], 1, N);                   %random data generation
x0_A        = 0.55;                                   %initial value of x0 at side A
x1_A        = logistic_map(mu_0, x0_A, 1, M);         %transient process at side A
xcont_A     = logistic_map(mu, x1_A, N, 0);           %continious sequence of size N at side A
xdisc_A     = binary_logistic(xcont_A, N);            %discrete sequence of size N at side A
u           = mod(information + xdisc_A, 2);          %encoded data at side A

%% Side B: Decoding
x0_B        = 0.61;                                   %initial value of x0 at side B
x1_B        = logistic_map(mu_0, x0_B, 1, M);         %encoding start point at side B
xcont_B     = logistic_map(mu, x1_B, N, 0);           %continious sequence of size N at side B
xdisc_B     = binary_logistic(xcont_B, N);            %discrete sequence of size N at side B
v           = mod(u + xdisc_B, 2);                    %decoded data at side B


%% Autocorrelation
% acf = autocorr(x1, samplesize - 1);
% ccf = crosscorr(x1, x2, samplesize - 1);

clf
p = autocorr(xdisc_A', N - 1);

%crosscorr(u, u, N - 1)



%% digital manipulation
z1 = qammod(xdisc_A',  16,'PlotConstellation',true);
z2 = qammod(xdisc_A' , 16, 'InputType', 'bit');
scatterplot(y);
fs = 200;
a = modulate(real(z1),70,fs,'qam',imag(z1));
plot(a)


%% Spectral Analysis
fs = 100;
dt = 1/fs;
t = (0:N-1)/fs;
y = fft(p);
power = abs(y).^2/N;
f = (0:N-1)*(fs/N)
plot(f,power)
xlabel('Frequency')
ylabel('Power')

y0 = fftshift(p);         % shift y values
f0 = (-N/2:N/2-1)*(fs/N); % 0-centered frequency range
power0 = abs(y0).^2/N;    % 0-centered power

plot(f0,power0)
xlabel('Frequency')
ylabel('Power')


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