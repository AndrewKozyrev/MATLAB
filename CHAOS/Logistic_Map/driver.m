%%  This script simulates discrete logistic map
%  x(n+1) = r*x(n)(1-x(n))

cd 'C:\Users\hitma\OneDrive\ROOT\Files\Job\Projects\MATLAB\CHAOS\Logistic_Map'
clc, clear, format long
% variables

mu      = 3.9;   %cipher parameter
mu_0    = 2.5;      %transit parameter
M       = 10^3;        %length of transit process
n       = 15;         %length of final sequence

object = LogisticMap(mu_0, mu, M);

for i=1:1:17
    message(i, :) = randi([0 1], 1, n);
    cypher(i, :) = object.decypher(message(i, :));
    temp = num2str(message(i, :));
    msg(i, :) = temp(~isspace(temp));
    temp = num2str(cypher(i, :));
    enc(i, :) = temp(~isspace(temp));
end

T = table();
T.cryptogram = msg;
T.message = enc;
writetable(T, 'decypher_example_15_bits.xlsx');