classdef LuckyTicket
    %LuckyTicket wraps all functions to solve the problem
    %   Detailed explanation goes here
     
    methods(Static)
        function retval = check(x)
            a = reverse( char(x) );
            retval.number = x;
            retval.sumofodd = sum( a(1:2:end) - '0' );
            retval.sumofeven = sum( a(2:2:end) - '0' );
            retval.status = retval.sumofodd == retval.sumofeven;
        end

        function y = increment(x, ptr)
            b = reverse( char(x) );
            if mod(length(b), 2) == 1
                b = strcat(b, '0');
            end
            c = cellstr( reshape(b, 2, [])' );
            trigger = true;     % sum of odd > sum of even
            pair = str2num( reverse( c{ptr} ) );
            d = LuckyTicket.check( pair );
            if d.sumofodd > d.sumofeven
                trigger = true;
            elseif d.sumofeven > d.sumofodd
                trigger = false;
            else
                y = x;
                return
            end

            T = not( trigger );
            while T ~= trigger
                pair = pair + 11;
                if length(num2str(pair)) == 3
                    temp = num2str(pair);
                    carry = str2num(temp(1));
                    pair = str2num( temp(2:end) );
                    try
                        nextpair = str2num( reverse(c{ptr + 1}) );
                        nextpair_changed = nextpair + carry;
                        temp2 = reverse( num2str(nextpair_changed) );
                        c(ptr + 1) = cellstr( temp2 );
                    catch E
                        if (strcmp(E.identifier, 'MATLAB:badsubscript'))
                            c(ptr + 1) = cellstr( num2str(carry) );
                        end
                    end
                end
                d = LuckyTicket.check( pair );
                if d.sumofodd > d.sumofeven
                    trigger = true;
                elseif d.sumofeven > d.sumofodd
                    trigger = false;
                else
                    break
                end
            end
            c( ptr ) = cellstr( reverse( num2str( pair, '%02d' ) ) );
            y = sym( reverse( strcat(c{:}) ) );
        end
        
        function y = nextTicket(x)
            x = sym(x);
            x_1 = x + 11 - mod(x, 11);
            a = LuckyTicket.check(x_1);
            % making even number of digits
            if mod(length(char(x)), 2) == 1
                x = strcat(char(x), '0');
            end
            % splitting digits into groups
            c = cellstr( reshape(char(x), 2, [])' );
            % total number of groups
            N = length(c);
            
            % trace of difference of sums of even and odd digits
            X = containers.Map('KeyType', 'double', 'ValueType', 'any');

            while a.status ~= true
                X(abs(a.sumofodd - a.sumofeven)) = a;
                for i=1:N
                    pivot = i;
                    x_2 = LuckyTicket.increment(a.number, pivot);
                    a = LuckyTicket.check(x_2);
                    if a.status
                        break
                    end
                    X(abs(a.sumofodd - a.sumofeven)) = a;
                    a = X(min(cell2mat(X.keys)));
                end
                
            end
            y = a.number;
        end
        
        % Try adding 110 to number)))
    end
end

