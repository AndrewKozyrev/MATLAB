cd 'C:\Users\hitma\OneDrive\ROOT\Files\Job\Projects\MATLAB\CHAOS\CCA'

a = -0.75;      % parameter
b = -0.55;      % parameter
x1 = -0.2;       % initial conditions
x2 = 0.2;       % initial conditions
M = 1005;       % number of elements left out for transient
N = 10^6;       % number of elements in a sequence

object = CCA(a, b, x1, x2, 8, N, M);

%%
object.displayPortrait('1', 8);
object.drawBorders(8);

% this yields key 14725836
%% Encoding example
L = 9;
for i = 1:1:17
    in{i} = num2str(join(string(randi([0 1], 1, L)), ''));
    temp = bin2dec(in{i});
    in_oct{i} = dec2base(temp, 8); 
    [out{i}, out_oct{i}] = object.decode(in{i}, i);
end
in = in';
in_oct = in_oct';
out_oct = out_oct';
out = out';
T = table(in, in_oct, out_oct, out)


