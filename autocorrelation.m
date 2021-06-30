function AC = autocorrelation(s, lag)
    sl = circshift(s, -lag);
    A = sum(sl == s);
    D = length(s) - A;
    AC = sym((A - D) / length(s));
end