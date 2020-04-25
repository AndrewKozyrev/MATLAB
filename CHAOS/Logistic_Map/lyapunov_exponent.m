function value = lyapunov_exponent(r, xseq)
%lyapunov_exponent computes distance between two orbits
%   f'(xi) = r - 2*r*xi

out1 = abs(r - 2*r*xseq);
out2 = log(out1);
out3 = sum(out2, 'omitnan');
value = out3/ length(xseq);
end
