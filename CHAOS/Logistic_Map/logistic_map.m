function x_out = logistic_map (r, x_0, N, M)
%logistic_map generates orbits
% equation for mapping x_n+1 = r*x_n*(1-x_n)
% arguments: r = parameter; x_0 = seed; N = length of sequence; M =
% transient count

% preliminary transient
for i=1:M
    xnew = r*x_0*(1-x_0);
    x_0 = xnew;
end

% recording
for j=1:1:N
    xnew = r*x_0*(1-x_0);
    x_0 = xnew;
    x_out(j) = xnew;
end

end


%{
%limit = 1/10;


fprintf('Entering convergent transient\n');


x_t = x_0;

% iterate once
xnew = r*x_0*(1-x_0);
distance = abs(xnew - x_t);

% convergent transient

while double(distance) ~= 0
    xnew = r*x_0*(1-x_0);
    x_0 = xnew;
    j=j+1;
    distance = abs(xnew - x_t);
    
    % check if distance converged
    if double(distance < limit)
        %fprintf('distance = %d;   limit = %d;   j = %d\n', distance, limit, j);
        limit = distance;
        x_t = xnew;
        xnew = r*x_0*(1-x_0);
    end
end
fprintf('It took [%d] iterations to pass transient process\n', j);

% otherwise "while" loop condition will be false from the start
%x_t = x_0;
%xnew = r*x_0*(1-x_0);

% after previous line distance is significantly more than it was
%distance = abs(xnew - x_t);
%clear splitC x
%coli = 1; rowi = 0;
%}