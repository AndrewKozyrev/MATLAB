x = sym(3^sym(1/2)-2^sym(1/2));
for i =1:1:length(e)
    A{i} = Dyadic.decypher(e(i, :),x, 10);
end

