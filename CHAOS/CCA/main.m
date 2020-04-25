a = -0.75;
b = -0.55;
x1 = 0.2;
x2 = 0.2;
M = 10^7;
N = 1000;

object = CCA(a, b, x1, x2, 8);

%% plot(seq(1:end-1), seq(2:end), '.', 'markersize', 5)
alpha = object.groupZones();
zone0 = alpha(0);
plot(zone0(1, :), zone0(2, :), '.', 'markersize', 5)
ylim([-1 1])
xlim([-1 1])
