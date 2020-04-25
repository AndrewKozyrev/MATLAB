function sequence  = IrrSeq(seed,group,N, varargin)
%Returns a sequence of numbers of length N, each number is of length
%'group' digits.
%   IrrSeq(seed, group, N, optional), returns a sequence of numbers grouped
%   by 'group' digits from an irrational number 'seed'.
x           =   sym(seed);

if ~isempty(varargin)
    type = varargin{1};
    if type == "binary"
        K   =   ceil(N/nextpow2(10^group))*group + 1;
    elseif type == "decimal"
        K   = N * group + 1;
    end
else
    type    = "binary";
    K       = ceil(N/nextpow2(10^group))*group;
end
old_digits  =   digits(K);
b           =   regexp(string(vpa(x)),'\d','match');
b           =   char(join(b, ''));
b           =   b(1:K-1);
c           =   cellstr(reshape(b,group,[])');
e           =   cellfun(@str2num, c);
if type == "binary"
    sequence    =   de2bi(e, nextpow2(10^group));
elseif type == "decimal"
    sequence    =   e;
end
sequence    =   sequence(:)';
sequence    =   sequence(1:N);

digits(old_digits)
end

