function [power,frequency] = PSD(signal,varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

N = length(signal);

if ~isempty(varargin)
    if length(varargin) > 1 && varargin{2} == "one-sided"
        y = fft(signal);
        y = y(1:N/2+1);
        frequency = varargin{1}/2*linspace(0, 1, length(y));
        % calculating power
        power = ( abs(y) ).^2 / N;
        power(2:end-1) = 2 * power(2:end-1);
    else
        y = fft(signal);
        frequency = varargin{1}*linspace(0, 1, N);
        power = ( abs( y ) ).^2 / N;
    end
else
    y = fft(signal);
    frequency = N*linspace(0, 1, N);
    % calculating power
    power = ( abs(y) ).^2 / N;
end

end

