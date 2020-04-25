%% This script creates upper Triangular matrix

n = 70;
matrix  = zeros(n);
matrix2 = zeros(n);

%populating matrix with values

for i= 1 : n
    for j= 1 : n
        if i <= j
            pow = sqrt(i*j);
            matrix(i, j) = 1.03^pow;
        end
    end
end

maxValue = max(max(matrix));

for i = 1 : n
    for j = 1 : n
        if i > j
            pow = sqrt(i*j);
            matrix2(i, j) = maxValue - 1.03^pow;
        else
            matrix2(i, j) = matrix(i, j);
        end
    end
end

figure(1), clf

subplot(121)
imagesc(matrix)
axis square, title('Upper-triangular matrix')
set(gca,'xtick', [], 'ytick', [])

subplot(122)
imagesc(matrix2)
axis square, title('Full matrix')
set(gca,'xtick', [], 'ytick', [])



        