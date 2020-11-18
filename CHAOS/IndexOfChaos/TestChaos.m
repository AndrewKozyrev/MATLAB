classdef TestChaos
    %TestChaos has group of tests that can be run on a sequence
    %   Histogram of distribution, autocorrelation, spectral test
    
    properties
        %% no attributes for the moment 
    end
    
    methods(Static)
        function self = TestChaos()
            %TestChaos Construct an instance of this class
            %   Does nothing at the moment
        end
        
        function [res, h, p] = chiSquare(s, varargin)
            %chiSquare gets pearson coeffs for all runs of sequence
            %   Give me a binary sequence, and I will run chi-square test for all
            %   possible partitions of your sequence. That is I will make
            %   a new sequence made from 1 bit, 2 bit, 3 bit, 4 bit, etc.
            %   subsequences. Then I will count frequency of occurance for
            %   each code word in new sequence and then I will calculate
            %   chi-square statistics.
            %   ARGUMENTS: s -- sequence to test
            %   varargin{1} -- write 'plot' to show a graph P-values for all partitions
            %   varargin{2} -- significance level, 0 < alpha < 1
            
            % By the way, I like to have bit-strings instead of arrays
            %str_s = sprintf('%d', s);
            if isa(s, 'char') || isa(s, 'string')
                seq = num2str(s) - '0';
            else
                seq = s;
            end
            
            if size(varargin, 2) > 1 && isa(varargin{2}, 'double')
                alpha = varargin{2};
                if alpha < 0 || alpha > 1
                    error("Significance level is incorrect.");
                end
            else
                alpha = 0.95;
            end
            
            N = length(seq);
            M = 50;
            % make sure that we have enough bits to make up to M-bit groups
            % example: 100 bits can make 1-bit, 2-bit, 3-bit, ..., 49-bit, 50-bit
            % partitions
            if M >= 0.5*N
                M = floor(0.5*N);
            end
            
            for n=1:1:M
                % I will try to group by n bits, but to achieve that I will
                % leave a multiple of n bits, the rest will be cut.
                N_cut   =   N - mod(N, n);
                temp    =   seq(1:N_cut);
                words   =   reshape(temp, n, [])';
                % I get some numbers in nums vector
                nums    =   bi2de(words, 'left-msb');
                % I want to get only unique elements
                nums_u  =   unique(nums);
                L_u     =   length(nums_u);
                L       =   length(nums);
                % Now I have nums vector with  L decimal numbers from groups of n bits each
                % time to calculate chi-square statistics
                K       =   2^n;
                x_i = histcounts(nums', [nums_u' (max(nums_u) + 0.5)]);
                m_i = L/K;      % expected frequency of occurence of any number
                c = sum(( x_i - m_i ).^2 / m_i) + L - L_u*(L/K);
                if c > chi2inv(1-alpha, K-1)
                    h(n) = 1;
                else
                    h(n) = 0;
                end
                p(n)    = chi2cdf(c, K-1, 'upper');
            end
            
            if size(varargin, 2) > 0 && varargin{1} == "plot"
                handle = plot(p, '.', 'markersize', 20);
                handle.LineStyle = '--';
                ylim([0 1]);
                hold on
                plot(xlim, [alpha alpha]);
                hold off
                xlabel('groups'); ylabel('P_v_a_l_u_e');
            end
            
            res = 1-sum(h)/M;
        end
        
        function result = fourierTest(signal, varargin)
            % This functions implements graphical spectral test
            %   Detailed explanation is not ready yet

            % Make sure a signal is a vector of integers
            if isa(signal, 'char') || isa(signal, 'string')
                signal = num2str(signal) - '0';
            end
            
            n = length(signal);
            s = nan(1, n);
            for i=1:1:n
                if signal(i) == 1
                    s(i) = 1;
                elseif signal(i) == 0
                    s(i) = -1;
                else
                    error("You gave me invalid signal.");
                end
            end
                    
            y1 = abs(fft(s));
            y2 = y1(1:ceil(n/2));
            plot(y2);
            xlabel('Frequency')
            ylabel('Power')
            hold on
            T = sqrt(log(1/0.05)*n);
            plot([0 length(y2)], [T T], 'linewidth', 2, 'linestyle', '--');
            hold off
            N_0 = 0.95*n/2;
            y3 = y2(y2 > 0);
            N_1 = sum(y3 < T);
            d = (N_1 - N_0) / sqrt(n * 0.95 * 0.05 / 4);
            P_value = erfc(abs(d)/sqrt(2));
            if P_value > 0.01
                result = true;
            else
                result = false;
            end
            
        end
        
        function res = Golomb(s)
            
            %Initially I assume the sequence is trully random
            res = ones(1, 3);
            if isa(s, 'char') || isa(s, 'string')
                seq = num2str(s) - '0';
            else
                seq = s;
            end
            
            N = length(seq);
            ni = histcounts(seq, [0 1 1.5]);
            if abs( ni(1) - ni(2) ) > 1
                res(1) = 0;
            end
            
            % Question is: how many runs of length n do we have in seq?
            count_ones = zeros(1, N); count_zeros = zeros(1, N);
            % partition sequence according to runs of different length
            cur = seq(1);
            partition = nan(1, N);
            partition(1) = 0;
            p_index = 2;
            for i=2:1:N
                if seq(i) ~= cur
                    partition(p_index) = i - 1;
                    len = partition(p_index)-partition(p_index-1);
                    if (cur == 1)
                        count_ones(len)   = count_ones(len) + 1;
                    else
                        count_zeros(len)  = count_zeros(len) + 1;
                    end
                    cur = seq(i);
                    p_index = p_index + 1;
                end
            end
            
            partition(p_index) = N;
            len = partition(p_index)-partition(p_index-1);
            if (cur == 1)
                count_ones(len)   = count_ones(len) + 1;
            else
                count_zeros(len)  = count_zeros(len) + 1;
            end
                    
            total_number_of_runs = sum(count_ones) + sum(count_zeros);
            T = nextpow2(total_number_of_runs);
            k = 1:1:T;
            runs_of_length_k = count_ones(1:T) + count_zeros(1:T);
            diff = abs(count_ones(1:T) - count_zeros(1:T));
            ratio = diff ./ runs_of_length_k;
            condition1 = runs_of_length_k < floor( total_number_of_runs ./ 2.^k );
            condition2 = runs_of_length_k ~= 0;
            condition3 = ratio > 0.02;
            condition4 = diff > 1;
            resulting_condition = condition1 | condition2 & condition3 & condition4;
            if any(resulting_condition)
                res(2) = 0;
            end
            
            % Now it's time to test for third postulate
            shifted_seq = circshift(seq, N-1);
            temp = (2*seq - 1).*(2*shifted_seq - 1);
            CONSTANT = sum(temp);
            for tau = 1:1:N-1
                shifted_seq = circshift(seq, N-tau);
                temp = (2*seq - 1).*(2*shifted_seq - 1);
                NR_tau = sum(temp);
                if any(NR_tau ~= CONSTANT)
                    res(3) = 0;
                    break
                end
            end
            
            shifted_seq = circshift(seq, 0);
            temp = (2*seq - 1).*(2*shifted_seq - 1);
            NR_tau = sum(temp);
            
            if NR_tau ~= N
                res(3) = 0;
            end
            
        end
    end
end

