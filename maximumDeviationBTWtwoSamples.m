%% calculate maximum deviation between two samples

inputfile = 'C:\Users\hitma\OneDrive\ROOT\Files\SPSUT\7TH_SEMESTER\Методы оптимизации сетей связи\LABORATORY\WORK_2\temp.xlsx';

%%
data_experiment = xlsread(inputfile, 'A1:F10');
data_theory = xlsread(inputfile, 'H1:M10');
data_experiment(:, 5) = data_experiment(:, 5) + data_experiment(:, 6);
data_experiment(:, 6) = data_experiment(:, 5) + 2;

%%
error = abs(data_experiment - data_theory);
max_error = max(max(error))