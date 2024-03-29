%%
cd 'C:\Users\hitma\OneDrive\ROOT\Files\Job\Projects\MATLAB\CHAOS\IrrationalNumbers';
clc, clear, format long

%% generation procedure
n = 1000000;
tic
x = sym(2^sym(1/2));
y = x;
k = 1000;
for i=1:1:n/k
    temp = vpa(y, 1000 + 400*i);
    s(i, :) = Dyadic.binary(temp, k);
    y = mod(2^(sym(i*k)) * x, 1);
end
cypher_time = toc
s1 = num2str(join(string(s), ''));

fid = fopen('root2_irrational_binary_1000000_digits.txt', 'w');
fprintf(fid,'%s', s1);
fclose(fid);