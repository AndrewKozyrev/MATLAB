classdef Dyadic
    %A collection of methods related to binary shift map
    %
    
    
    methods (Static)
        function obj = Dyadic()
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
        end
        
        function x_out = BSM(x_in)
            %BSM is an acronym for Binary Shift Map
            %   takes a real-valued argument x_in from [0 1] and applies the
            %   following x_out = 2*x_in mod 1
            if 0 <= double(x_in) && double(x_in) < 0.5
                x_out = 2*x_in;
            elseif 0.5 <= double(x_in) && double(x_in) <= 1
                x_out = 2*x_in - 1;
            else
                error("Wrong argument: %d", x_in);
            end
            
        end
        
        function sequence = IrrSeq(seed,group,N, varargin)
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
            b           =   b(1:K);
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
        
        function y = f_d2b(n, varargin)
           %-----------------------------------------------------------------------
           %PROGRAMMER:
           %GORDON NANA KWESI AMOAKO
           %EMAIL: kwesiamoako@gmail.com || gsnka@yahoo.com
           % Modified: 14 JULY 2012
           %-----------------------------------------------------------------------


           %MATLAB's dec2bin( ) function just converts whole numbers to binary
           %This function f_d2b( ) provides an extended functionality of converting
           %numbers with fractions or fractions only to BINARY
           %----------------------------------------------------------------------
           %
           %INPUT: n e.g. 25.625
           %OUTPUT: Binary number e.g. 11001.101
           %
            %Converting the Number to String

            %------------------------------------------------
            if double(mod(n, 1)) == 0   
                y=dec2bin(double(n));
                return;        
            end
            %------------------------------------------------

            %Retrieving INTEGER and FRACTIONAL PARTS as strings
            i_part=double(n - mod(n, 1));
            f_part=mod(n, 1);
            
            old_digits = digits();
            if size(varargin, 2) > 0 && isa(varargin{1}, 'double') && varargin{1} < 1000
                digits(varargin{1});
            end
            %Converting the strings back to numbers
            ni_part=double(i_part);
            nf_part=sym(f_part);

            ni_part=dec2bin(ni_part);

            strtemp='';


            temp=nf_part;
            %-------------------------------------------------
            t='1';s='0';
            T = Dyadic.findPeriod(nf_part);
            if T ~= 0
                I = Dyadic.wherePeriod(nf_part, T);
                for i=1:1:T + I
                    nf_part=nf_part*2;
                    if (nf_part==1) || (nf_part==temp)
                        strtemp=strcat(strtemp,t);
                        break;
                    elseif nf_part>1
                        strtemp=strcat(strtemp,t);
                        nf_part=nf_part-1;
                    else
                        strtemp=strcat(strtemp,s);
                    end
                end
                y=strcat(ni_part,'.',strtemp(1:I), '(', strtemp(I+1:end), ')');
                
            else
                while nf_part ~= 0
                    nf_part=nf_part*2;
                    if (nf_part==1) || (nf_part==temp)
                        strtemp=strcat(strtemp,t);
                        break;
                    elseif nf_part>1
                        strtemp=strcat(strtemp,t);
                        nf_part=nf_part-1;
                    else
                        strtemp=strcat(strtemp,s);
                    end
                end
                y=strcat(ni_part,'.',strtemp);
            end

             
            digits(old_digits);
            %------------------------------------------------
        end
        
        function T = findPeriod(x)
            % Computes period of a sequence with initial condition x
            % INPUT: 0.625    OUTPUT: 0
            % INPUT: 0.(9)    OUTPUT: 1
            % INPUT: 13/36    OUTPUT: 6
            % INPUT: 0.2      OUTPUT: 3
            
            T = 1;
            y = Dyadic.BSM(x);
            
            
            % Transient process
            % assume the sequence converges
            delta = y;
            max = 100;
            k = 1;
            while max > 0
                y = Dyadic.BSM(y);
                if double(y) < double(delta)
                    delta = y;
                    max = max + 10*k^2;
                    k = k + 1;
                end
                if y == 0
                    T = 0;
                    return;
                end
                max = max - 1;
            end
            
            x = y;
            y = Dyadic.BSM(x);

            while double(abs(y - x)) ~= 0
                y = Dyadic.BSM(y);
                T = T + 1;
            end
            
        end
        
        function I = wherePeriod(x, T)
            % this fucntion determines where the Period T starts
            % INPUT: 13/36     OUTPUT: 2
            % INPUT: 0.2       OUTPUT: 0
            % INPUT: 1/3       OUTPUT: 0
            % INPUT: 1/6       OUTPUT: 1
            I = 0;
            x_0 = x;
            y = Dyadic.BSM(x);
            
            while y ~= x_0
                for i=1:1:T-1
                    y = Dyadic.BSM(y);
                end
                if y ~= x_0
                    I = I + 1;
                    x_0 = Dyadic.BSM(x_0);
                    y = Dyadic.BSM(x_0);
                end
            end
        end
        
        function [S, Z] = getSequence(x)
            % return a sequence of real-valued numbers when BSM is applied
            % to x
            x = sym(x);
            T = Dyadic.findPeriod(x);
            I = Dyadic.wherePeriod(x, T);
            S = [];
            Z = [];
            % Transient
            for i=1:1:I
                Z(numel(Z)+1) = x;
                x = Dyadic.BSM(x);
            end
            x_0 = x;
            S(1) = x_0;
            y = Dyadic.BSM(x_0);
            % Write to array
            while y ~= x_0
                S(numel(S)+1) = y;
                y = Dyadic.BSM(y);
            end
            
        end
        
        function x = getChaos(x_0, N, M)
            
            for j=1:1:M
                x_0 = Dyadic.BSM(x_0);
            end
            x = nan(1, N);
            x(1) = x_0;
            for i=2:1:N
                x(i) = Dyadic.BSM(x(i-1));
            end
        end
        
        function y = getBinary(x, n)
            
            x = sym(x);
            y = '';
            temp = x;
            t = '1';
            s = '0';
            
            for i=1:1:n
                x = x * 2;
                if (x == 1) || (x == temp)
                    y = strcat(y,t);
                    break;
                elseif double(x) > 1
                    y = strcat(y, t);
                    x = x - 1;
                else
                    y = strcat(y , s);
                end 
            end
            
            y = y - '0';
            
        end
        
        function e = cypher(m, x, l)
            % m - message, x - seed, l - shift
            % output e - encrypted message
            %
            n = length(m); 
            s = Dyadic.getBinary(x, n + l);
            e = double(xor(m, s(l+1:end)));
        end
        
        function d = decypher(e, x, l)
            % e - crypted message, x - seed, l - shift
            % output d - decrypted message
            %
            n = length(e); 
            s = Dyadic.getBinary(x, n + l);
            d = double(xor(e, s(l+1:end)));
        end
    end
end

