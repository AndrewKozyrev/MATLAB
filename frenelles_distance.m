%% расчёт радиуса зоны Френеля

clear, clc

d = [50 80]; %km
f = [5.1 5.5];    %GHz


d1(1, :) = linspace(0, d(1), 23);    %растояние от первой антены до указанной точки
d1(2, :) = linspace(0, d(2), 23);

%initialize radius
radius = nan(size(d1));

%растояние от второй антены до нужной точки разбиения
d2(1, :) = d(1) - d1(1, :);     
d2(2, :) = d(2) - d1(2, :);

%calculate radius
radius(1, :) = 17.31*sqrt( (d1(1, :).*d2(1, :))./(f(1)*(d1(1, :)+d2(1, :))) );
radius(2, :) = 17.31*sqrt( (d1(2, :).*d2(2, :))./(f(2)*(d1(2, :)+d2(2, :))) );

d1(1, :) = round(d1(1, :), 2);
d2(2, :) = round(d2(2, :), 2);
radius(1, :) = round(radius(1, :), 2);
radius(2, :) = round(radius(2, :), 2);

T = table(d1', d2', radius');

%writetable(T,'myData.xls','Sheet',1,'Range', 'A1');

clf
p = plot(d1(1, 2:end-1), radius(1, 2:end-1), d1(2, 2:end-1), radius(2, 2:end-1));
hold on
h1 = plot([1 1]*d(1)/2, get(gca, 'ylim'), [1 1]*d(2)/2, get(gca, 'ylim'));
h2 = plot(get(gca, 'xlim'), [1 1]*radius(1, 12), get(gca, 'xlim'), [1 1]*radius(2, 12));
hold off
p(1).LineWidth = 2;
p(2).LineWidth = 2;
h1(1).LineStyle = '--';
h1(2).LineStyle = '--';
h2(1).LineStyle = '--';
h2(2).LineStyle = '--';
legend('d = 50, f = 5.1', 'd = 80, f = 5.5');
xlabel('d_1');
ylabel('радиус зоны');
title('R = f(d_1)');