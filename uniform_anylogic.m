pd2 = makedist('Uniform','lower',0.4226,'upper',1.5774);

filename = 'C:\Users\hitma\OneDrive\ROOT\Files\SPSUT\7TH_SEMESTER\Методы оптимизации сетей связи\LABORATORY\WORK_5\таблица_1.xlsx';
ni = xlsread(filename, 'C9:C19');
% Compute the pdfs
x_lower = xlsread(filename, 'A9:A19');
x_upper = xlsread(filename, 'B9:B19');

F_lower = 1 - exp(-x_lower);
F_upper = 1 - exp(-x_upper);
pi = F_upper - F_lower;

n = sum(ni);
pearson = (ni - n*pi).^2 ./ (n*pi);

