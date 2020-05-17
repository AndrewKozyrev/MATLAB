cd 'C:\Users\hitma\OneDrive\ROOT\Files\Job\Projects\MATLAB\CHAOS\CCA'

a = -0.75;      % parameter
b = -0.55;      % parameter
x1 = -0.2;       % initial conditions
x2 = 0.2;       % initial conditions
M = 0;       % number of elements left out for transient
N = 10^6;       % number of elements in a sequence

object = CCA(a, b, x1, x2, 8, N, M);

%%
object.displayPortrait(5, 8, 3, 6, 1, 4, 7, 2);
object.drawBorders(5, 8, 3, 6, 1, 4, 7, 2);

%%
% 1 -> 4           0 -> 5
% 2 -> 7           1 -> 8
% 3 -> 2           2 -> 3
% 4 -> 5           3 -> 6
% 5 -> 0           4 -> 1
% 6 -> 3           5 -> 4
% 7 -> 6           6 -> 7
% 8 -> 1           7 -> 2

% 58361472
% this yields key 14725836
k = 8;
for i = 1:1:(2^k-1)
    in_d(i) = i;
    in_b{i} = dec2bin(in_d(i), k);
    in_oct{i} = dec2base(in_d(i), 8);
    [e_oct{i}, e_dec{i}] = object.encode(in_d(i), i);
    [d_oct{i}, d_dec{i}] = object.decode(e_oct{i}, i);
    out_b{i} = dec2bin(str2double(d_dec{i}), k);
end
in_b = in_b';
in_d = in_d';
in_oct = in_oct';
e_oct = e_oct';
e_dec = e_dec';
d_oct = d_oct';
d_dec = d_dec';
out_b = out_b';
T = table(in_b, in_d, in_oct, e_oct, e_dec, d_oct, d_dec, out_b)


