cd 'C:\Users\hitma\OneDrive\ROOT\Files\Job\Projects\MATLAB\CHAOS\CCA'

a = -0.75;      % parameter
b = -0.511;      % parameter
x1 = -0.2;       % initial conditions
x2 = 0.2;       % initial conditions
M = 10^6;       % number of elements left out for transient
N = 10^7;       % number of elements in a sequence

object = CCA(a, b, x1, x2, 13, N, M);

%%
object.displayPortrait('1');
object.drawBorders();

% this yields key 14725836
%% Encoding example
L = 8;
for i = 1:1:17
    in_b{i} = join(string(randi([0 1], 1, L)), '');
    in_d{i} = bin2dec(in_b{i});
    in_oct{i} = dec2base(in_d{i}, 8);
    [d_oct{i}, d_dec{i}] = object.encode(in_oct{i}, i);
    out_b{i} = dec2bin(str2double(d_dec{i}), L);
end
in_b = in_b';
in_d = in_d';
in_oct = in_oct';
%e_oct = e_oct';
%e_dec = e_dec';
d_oct = d_oct';
d_dec = d_dec';
out_b = out_b';
T = table(in_b, in_d, in_oct, d_oct, d_dec, out_b)


