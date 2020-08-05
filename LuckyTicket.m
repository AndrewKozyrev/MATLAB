classdef LuckyTicket
    %LuckyTicket wraps all functions to solve the problem
    %   Detailed explanation goes here
     
    methods(Static)
        function retval = check(x)
            a = reverse( num2str(x) );
            retval.number = x;
            retval.sumofodd = sum( a(1:2:end) - '0' );
            retval.sumofeven = sum( a(2:2:end) - '0' );
            retval.status = retval.sumofodd == retval.sumofeven;
        end

        function y = increment(x, ptr)
            b = reverse( num2str(x) );
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
                    nextpair = str2num( reverse(c{ptr + 1}) );
                    nextpair_changed = nextpair + carry;
                    temp2 = reverse( num2str(nextpair_changed) );
                    c(ptr + 1) = cellstr( temp2 );
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
            z = str2num( reverse( strcat(c{:}) ) );
            a = LuckyTicket.check(z);
            ptr = ptr + 1;
            y = 1;
        end
        
        function y = nextTicket(x)
            x_1 = x + 11 - mod(x, 11);
            a = LuckyTicket.check(x_1);
            while a.status ~= true
                x_2 = increment(a.number);
                a = LuckyTicket.check(x_2);
            end
            y = a.number;
        end
    end
end

