classdef LogisticMap
    %LogisticMap Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mu_0
        mu
        transient_count
    end
    
    methods
        function self = LogisticMap(m_0, m, M, N)
            %LogisticMap Construct an instance of this class
            %   Detailed explanation goes here
            self.mu_0   = m_0;
            self.mu     = m;
            self.transient_count = M;
        end
        
        function xseq = getSequence(self, N, varargin)
            %logistic_map generates orbits
            % equation for mapping x_n+1 = r*x_n*(1-x_n)
            % arguments: N = length of sequence; varargin{1} = x_0;
            % varargin{2} = mu; varargin{3} = M
            
            x_0 = rand;
            
            if size(varargin, 2) > 0 && isa(varargin{1}, 'double')
                x_0 = varargin{1};
            end
            
            if size(varargin, 2) > 1 && isa(varargin{2}, 'double')
                r = varargin{2};
            else
                r = self.mu;
            end
            
            xseq = nan(1, N);

            if size(varargin, 2) > 2 && isa(varargin{3}, 'double')
                M = varargin{3};
            else
                M = self.transient_count;
            end
            
            % preliminary transient
            for i=1:M
                xnew = r*x_0*(1-x_0);
                x_0 = xnew;
            end
            
            % recording
            for j=1:1:N
                xnew = r*x_0*(1-x_0);
                x_0 = xnew;
                xseq(j) = xnew;
            end
            
        end
        
        function value = lyapunovExponent(self, xseq)     
            %lyapunov_exponent computes distance between two orbits
            %   f'(xi) = r - 2*r*xi
            r = self.mu;
            out1 = abs(r - 2*r*xseq);
            out2 = log(out1);
            out3 = sum(out2, 'omitnan');
            value = out3/ length(xseq);
            
        end
        
        function [e, b, x3] = cypher(self, m)
            N = length(m);
            x0 = rand;
            x1 = self.getSequence(1, x0, self.mu_0);
            x2 = round(x1, 9);
            x3 = self.getSequence(1, x2, self.mu);
            xseq = self.getSequence(N, x3, self.mu, 0);
            b = self.binary(xseq);
            e = double(xor(b, m));
        end
        
        function [d, b, x3] = decypher(self, e)
            N = length(e);
            x0 = rand;
            x1 = self.getSequence(1, x0, self.mu_0);
            x2 = round(x1, 9);
            x3 = self.getSequence(1, x2, self.mu);
            xseq = self.getSequence(N, x3, self.mu, 0);
            b = self.binary(xseq);
            d = double(xor(b, e));
        end
    end
    
    methods(Static)
        function x_bin = binary(seq_x)
            %binary translates real-valued logistic map sequence into
            %binary sequence
            %   x_t is treshold value
            N = length(seq_x);
            x_t     = mean(seq_x);
            x_bin   = nan(1, N);

            for i=1:1:N
                if seq_x(i) < x_t
                    x_bin(i) = 0;
                else
                    x_bin(i) = 1;
                end
            end
        end
    end
end

