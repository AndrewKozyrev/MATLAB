%%  This script simulates discrete logistic map
%  x(n+1) = r*x(n)(1-x(n))

cd 'C:\Users\hitma\OneDrive\ROOT\Files\Job\Projects\MATLAB\CHAOS\Logistic_Map'
clear, format long
% variables

mu      = 4;   %cipher parameter
mu_0    = 2.5;      %transit parameter
M       = 10^6;        %length of transit process
n       = 15;         %length of final sequence

object = LogisticMap(mu_0, mu, M);

%% Encoding cycle
tic
step = 0.000000000001;
T = table();
for i=1:1:17
    input = zeros(1, 15);
    T.input(i, :) = num2str(join(string(input), ''));
    [o, c, x2{i}] = object.decypher(input);
    output{i} = num2str(join(string(o), ''));
    cypher{i} = num2str(join(string(c), ''));
    T.key(i, :) = cypher{i};
    T.encoded(i, :) = output{i};
    mu_0 = mu_0 + step;
    object.mu_0 = mu_0;
end
end_time = toc
writetable(T, 'cypher_example_15bit.xlsx');

%% Decoding
tic
step = 0.000000000001;
data = readtable('cypher_example_15bit.xlsx').encoded;
T = table();
for i=1:1:17
    input = data{i} - '0';
    T.input(i, :) = data{i};
    [o, c, x2{i}] = object.decypher(input);
    message{i} = num2str(join(string(o), ''));
    cypher{i} = num2str(join(string(c), ''));
    T.key(i, :) = cypher{i};
    T.decoded(i, :) = message{i};
    mu_0 = mu_0 + step;
    object.mu_0 = mu_0;
end
end_time = toc
writetable(T, 'decypher_example_15bit.xlsx');


%% Lyapunov exponent Test
tic
r = 1;
object.mu = r;
x0 = 0.5;
x1 = object.getSequence(10^1, x0, 1, 10^8);
x2 = object.getSequence(10^1, x0 + 0.1, 1, 10^8);
l = object.lyapunovExponent(x);
end_time = toc


%% Presentation mode
x_0 = 0.6;
m = 15;
n = 1:1:m;
seq = object.getSequence(m, x_0, 3.9, 0);
plot(n, seq(n), 'b.', 'markersize', 15)
hold on
%plot(0, x_0, 'b.', 'markersize', 15)
plot([0 m], [mean(seq) mean(seq)], 'r--')
xbounds = xlim;
set(gca,'XTick',xbounds(1):xbounds(2));
ylim([0 1])
xlabel("n")
ylabel("x_n")
hold off


%% Autocorrelation
seq1 = object.getSequence(10^3, rand);
bin_seq1 = LogisticMap.binary(seq1);
subplot(211)
autocorr(bin_seq1, 999)
ylim([-1 1])
xlabel("Ò‰‚Ë„"); ylabel("¿ ‘");
seq2 = object.getSequence(10^3, rand);
bin_seq2 = LogisticMap.binary(seq2);
subplot(212)
[c,lags] = xcorr(bin_seq1, bin_seq2, 999, 'biased');
stem(lags(1000:end),c(1000:end))
ylim([0 1])
xlabel("Ò‰‚Ë„"); ylabel("¬ ‘");