%% This script calculates data for radio signal detoriation


clear, clc
% �������� ���������

%������� ������� �1
frequency_1 = 900; % MHz

%������� ������� �2
frequency_2 = 1525; %MHz

%������ ������� �������
heightBS   = 55; % m

%������ ������� ��������� �������
heightAS   = 6.5; % m

%���������� ����� ������������ � ���������
distance = 1:1:10;

% ��������� �������� ������ �� ������ ����

%����������� ����������� ��� ������ ������� ��������� �������, 
%����������� ���� ������ a(heightAS), ��
a_heightAS = nan(1, 2);

%a_heightAS(1) -- ��� ������� �������
if frequency_1 < 300
    a_heightAS(1) = 8.29*( log10(1.54*heightAS) )^2 - 1.1;
else
    a_heightAS(1) = 3.2*( log10(11.75*heightAS) )^2 - 4.97;
end

%a_heightAS(2) -- ��� ����� � ������� �������
a_heightAS(2) = (1.1*log10(frequency_1) - 0.7)*heightAS - (1.56*log10(frequency_1)-0.8);  % dB

%losscoeff -- ����������� ������ ������� 
losscoeff = nan(4, numel(distance));

%losscoeff(1) -- ������� ������ � ������� ������
losscoeff(1, :) = 69.55+26.16*log10(frequency_1) - 13.83*log10(heightBS)+...
    (44.9 - 6.55*log10(heightBS)).*log10(distance)- a_heightAS(1); %dB

%losscoeff(2) -- ������� ������ ��� ����� � ������� �������
losscoeff(2, :) = 69.55+26.16*log10(frequency_1) - 13.83*log10(heightBS)+...
    (44.9 - 6.55*log10(heightBS)).*log10(distance)- a_heightAS(2); %dB

%losscoeff(3) -- ������� ������ ��� ����������� �������
losscoeff(3, :) = losscoeff(2, :) - 2*( log10(frequency_1/28) ).^2 - 5.4; %dB

%losscoeff(4) -- ������� ������ ��� �������� ��������� 
losscoeff(4, :) = losscoeff(2, :) - 4.78*( log10(frequency_1) ).^2 + 18.33*log10(frequency_1) - 40.94; %dB


%% ������ ��� ������ ����
p = plot(distance, losscoeff );
legend('������� �����', '����� �����', '��������', '�������� ���������', 'location', 'southeast')
title("������ � ������ ����, L_�_�(d)")
xlabel('����������, �')
ylabel("������, ��")
grid on , grid minor , box off
p(1).Marker = '.'; p(2).Marker = '.'; p(3).Marker = '.'; p(4).Marker = '.';
p(1).MarkerSize = 15; p(2).MarkerSize = 15; p(3).MarkerSize = 15; p(4).MarkerSize = 15;
ylim([0 ceil(max(losscoeff, [], 'all')) + 10])


%% ������ COST231-����

%������������� ������������ ������
losscost231 = nan(3, numel(distance));

%losscost231(1) -- ������� ������ � ������� ������
losscost231(1, :) = 46.3+33.9*log10(frequency_2) - 13.82*log10(heightBS)+...
    (44.9 - 6.55*log10(heightBS)).*log10(distance)- a_heightAS(1) + 3; %dB

%losscost231(2) -- ������� ������ ��� ����� � ������� �������
losscost231(2, :) = losscost231(1, :) - 3 + a_heightAS(1) - a_heightAS(2); %dB

%losscost231(3) -- ������� ������ � �������� ���������
losscost231(3, :) = losscost231(2, :) - 4.78*( log10(frequency_2) ).^2 + 18.33*log10(frequency_2) - 40.94; %dB

%% ������ ��� ������ COST231-����
p = plot(distance, losscost231 );
legend('������� �����', '������� �����', '�������� ���������', 'location', 'southeast')
title("������ � ������ COST231-����, L_�_�(d)")
xlabel('����������, �')
ylabel("������, ��")
grid on , grid minor , box off
p(1).Marker = '.'; p(2).Marker = '.'; p(3).Marker = '.';
p(1).MarkerSize = 15; p(2).MarkerSize = 15; p(3).MarkerSize = 15;
ylim([0 ceil(max(losscost231, [], 'all')) + 10])


%% ������ � Excel
T = table(losscost231');
filexls = 'myData.xls';
writetable(T, filexls, 'Sheet', 1, 'Range', 'A1');