%% problem 3.4.14

%x' = rx + x^3 -x^5
clc, clear
r = linspace(1, 10, 10);

x = linspace(-5, 5, 1000000);
f = nan(length(r), length(x));

for ri=1:numel(r)
    f(ri, :) = r(ri) * x - sin(x);
end

clf
handle = plot(x, f(:, :), 'linew', 1);
grid on
set(gca, 'ylim', [-2 2])
set(gca, 'xlim', [-1 1]*2*pi)
xL = xlim;
yL = ylim;
line([0 0], yL);  %x-axis
line(xL, [0 0]);  %y-axis