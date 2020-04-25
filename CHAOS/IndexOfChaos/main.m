%% Our noise
noise_1 = IrrSeq(2^0.5, 4, length(t), 'decimal');   % irrational number noise
noise_1 = (noise_1 - mean(noise_1));

noise_2 = logistic_map(3.9999, 0.55, length(t), 10^6);  % logistic map noise
noise_2 = (noise_2 - mean(noise_2));
noise_2 = 2.5*noise_2/max(noise_2);

noise_3 = 2.5*gallery('normaldata',size(t),4); % Gaussian noise;

%% Autocorrelation
autocorr(noise, 100 )
ylim([-0.05 0.05])

%% Probability density estimate
[f, xi] = ksdensity(noise);
plot(xi, f, 'marker', 'o', 'markersize', 10);
xlim([floor(min(noise)) ceil(max(noise))])
xlabel('x_i')
ylabel('p(x_i)')
title("Logistic(3.9999, 0.55, 10^5)")


%% Spectral Analysis
noise = noise_1;
fs = 100;                                % sample frequency (Hz)
T = 1/fs;                                % sample duration
L = 100000;                                % length of signal
t = (0:L-1)*T;                           % time vector

x = (1.3)*sin(2*pi*15*t) ...             % 15 Hz component
  + (1.7)*sin(2*pi*40*(t-2));            % 40 Hz component
v = x + noise;

subplot(2, 1, 1)
plot(t, v)
title('Signal Corrupted with Noise')
xlabel('time (seconds)')

[power, f] = PSD(v, fs, 'one-sided');

subplot(2, 1, 2)
plot(f,power, 'linew', 0.5)
xlabel('Frequency')
ylabel('Power')


