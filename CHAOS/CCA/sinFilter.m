function [x,y] = sinFilter(x1,x2, a, b, M, N)
% Recurrent formula for simple sinusoidal filter
%% M = decay factor; N = length of sequence; a,b,x1,x2 - initial parameters; 
y = a*x2 + b*x1;

% transient decay process
for i=1:M
    x3 = sin( pi*y );
    x1 = x2;
    x2 = x3;
    y = a*x2 + b*x1;
end

clear x y
% recording cycle
for j=1:N
    y(j) = a*x2 + b*x1;
    x3 = sin( pi*y(j) );
    x1 = x2;
    x2 = x3;
    x(j) = x3;
end

end