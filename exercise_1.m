%%
filename = 'enigma.txt';

fID = fopen(filename, 'r');

text = fscanf(fID, '%c');
% text = 'w{N6}7AMN(}JE.^XHCT}AH(7)^C%+HR.BZO)R\=?T1{Y4}'

% a = '\a*\b*\f*\n*\r*\t*\v*';
a = '\D*';
expression = ['[a-z]' a '{' a '[A-Z]' a '\d' a '}' a '\d' a '\D*' a ...
    '\(' a '\d*' a '\)' a '\D*' a '\d' a '{' a '[A-Z]' a '\d' a '}.'];
text1 = regexp(text, expression, 'match');
text2 = cellfun(@string, text1)';
text3 = regexp(text2, '(\d\)', 'match');
text4 = cellfun(@string, text3);

data0 = split(text4, '');
data1 = data0(:, 3);
data2 = str2double(data1);
product = prod(data2)

fclose(fID);