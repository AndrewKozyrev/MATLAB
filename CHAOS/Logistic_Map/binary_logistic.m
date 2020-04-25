function x_bin = binary_logistic(seq_x, N)
%binary_logistic translates real-valued logistic map sequence into binary
%   x_t is treshold value
x_t     = mean(seq_x);
x_bin   = [];

for i=1:N
    if seq_x(i) < x_t
        x_bin(i) = 0;
    else
        x_bin(i) = 1;
    end
end
end

