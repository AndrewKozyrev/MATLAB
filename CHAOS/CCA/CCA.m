classdef CCA < handle
    %CCA class describes chaotic cyclic attractor
    %   methods: 
    % getSequence() :  returns [x y] sequence
    % groupZones() : returns groups of zones
    % drawBorders() : void, draws borders around zones
    % displayPortrait() : displays given zones: 'one' - particular zone, 'all' - all zones
    % identify() : returns the number of zone given point belongs to
    
    properties (SetAccess = immutable)
        a
        b
        period
        seed_x1
        seed_x2
    end
    properties (SetAccess = public)
        x1
        x2
        transient_count = 10^4;
        sequence_length = 10^5;
        initialized = false;
    end
    
    methods
        function self = CCA(in_a, in_b, in_x1, in_x2, in_period, varargin)
            %CCA Construct an instance of this class
            %   Initialize all possible parameters
            self.a = in_a;
            self.b = in_b;
            self.seed_x1 = in_x1;       self.x1 = in_x1;
            self.seed_x2 = in_x2;       self.x2 = in_x2;
            self.period = in_period;
            if size(varargin, 2) > 0
                self.sequence_length = varargin{1};
            end
            if size(varargin, 2) > 1
                self.transient_count = varargin{2};
            end
            if size(varargin, 2) > 2
                error("Constructor doesn't accept so much arguments.");
            end
            self.transient(self.transient_count, true);
        end
        
        function drawBorders(self, varargin)
            %drawBorders draws grid like borders over chaotic zones on the
            %phase plane
            %   Depending on period, this function iterates through all
            %   chaotic zones and plots borders for each
            dict = self.groupZones(false);
            if size(varargin, 2) == 0
                for i=1:1:self.period
                    temp    = dict(i);   %in case somebody throws me a floating value:o)
                    left    = min(temp(1,:)); 
                    right   = max(temp(1,:)); 
                    bottom  = min(temp(2,:)); 
                    top     = max(temp(2,:));
                    hold on
                    plot([left left], [bottom top], '--r')
                    plot([right right], [bottom top], '--r')
                    plot([left right], [bottom bottom], '--r')
                    plot([left right], [top top], '--r')
                end
                ylim([-1 1]);
                xlim([-1 1]);
                hold off;
            elseif size(varargin, 2) == 1 && isa(varargin{1}, 'double') ...
                            && 0 < varargin{1} && varargin{1} <= self.period
                temp = dict(fix(varargin{1}));   %in case somebody throws me a floating value:o)
                left    = min(temp(1,:)); 
                right   = max(temp(1,:)); 
                bottom  = min(temp(2,:)); 
                top     = max(temp(2,:));
                hold on
                plot([left left], [bottom top], '--r')
                plot([right right], [bottom top], '--r')
                plot([left right], [bottom bottom], '--r')
                plot([left right], [top top], '--r')
                ylim([-1 1]);
                xlim([-1 1]);
                hold off
            elseif size(varargin, 2) > 1 && size(varargin, 2) <= self.period
                for i=1:1:size(varargin, 2)
                    temp = dict(varargin{i});
                    left    = min(temp(1,:)); 
                    right   = max(temp(1,:)); 
                    bottom  = min(temp(2,:)); 
                    top     = max(temp(2,:));
                    hold on
                    plot([left left], [bottom top], '--r')
                    plot([right right], [bottom top], '--r')
                    plot([left right], [bottom bottom], '--r')
                    plot([left right], [top top], '--r')
                end
                ylim([-1 1]);
                xlim([-1 1]);
                hold off;                
            else
                error("The arguments are not valid");
            end
        end
        
        function mapping = groupZones(self, varargin)
            n = self.period;
            if size(varargin, 2) == 1
                [x, ~] = self.getSequence(varargin{1});
            else
                [x, ~] = self.getSequence();
            end
            mapping = containers.Map('KeyType','uint64','ValueType','any');
            for i=1:n
                mapping(i) = [x(i:n:end-1); x(i+1:n:end)];
            end
        end
        
        function [x, y] = getSequence(self, varargin)
            %retrieves a sequence from chaotic system of equations
            
            % declare local variables
            M = self.transient_count;
            N = self.sequence_length;
            temp_x1 = self.x1;
            temp_x2 = self.x2;
            temp_a = self.a;
            temp_b = self.b;
            y = temp_a*temp_x2 + temp_b*temp_x1;
            % end of local variables declaration
                 
            % transient decay process                       
            if self.initialized == false
                % drop first M unwanted points
                self.transient(M);
                self.initialized = true;
            end
            
            clear x y
            x = zeros(1, N);
            y = zeros(1, N);
            % recording cycle
            for j=1:N
                y(j)  = temp_a*temp_x2 + temp_b*temp_x1;
                x3    = sin( pi*y(j) );
                temp_x1    = temp_x2;
                temp_x2    = x3;
                x(j)  = x3;
            end
            % update the initial condition variables if asked
            if size(varargin, 2) == 1 && isa(varargin{1}, 'logical') && varargin{1}
                self.x1 = x(end-1);
                self.x2 = x(end);
            end
        end
        
        function x_next = transient(self, M, varargin)
            % local variables again
            temp_x1 = self.x1;
            temp_x2 = self.x2;
            temp_a = self.a;
            temp_b = self.b;
            y = temp_a*temp_x2 + temp_b*temp_x1;            
            for i=1:M
                x3 = sin( pi*y );
                temp_x1 = temp_x2;
                temp_x2 = x3;
                y = temp_a*temp_x2 + temp_b*temp_x1;
            end
            new_x1 = temp_x1;
            new_x2 = temp_x2;
            x_next = [new_x1 new_x2];
            if size(varargin, 2) == 1 && isa(varargin{1}, 'logical') && varargin{1}
                self.x1 = new_x1;
                self.x2 = new_x2;
            end
        end
        
        function displayPortrait(self, m, varargin)
            % m is for 'marker size' by default, it should be 3.
            if ~isa(m, "string") && ~isa(m, "char")
                error("Give me marker size with quotes.");
            end
            m = str2num(m);
            dict = self.groupZones(false);
            %varargin is taking the # of zone to plot in case your are
            %wondering what's happening
            %if 1 argument, plot 1 zone
            %if 2 or more arguments, plot in a loop
            if size(varargin, 2) == 0
                for i=1:1:self.period
                    temp = dict(i);
                    plot(temp(1, :), temp(2, :), '.', 'markersize', m, 'color', 'b');
                    xlabel("x_n"); ylabel("x_n_+_1"); title("\alpha = " + self.a + ", \beta = " + self.b);
                    grid on, box off, grid minor
                    hold on;
                end
                ylim([-1 1]);
                xlim([-1 1]);
                hold off;
            elseif size(varargin, 2) == 1 && isa(varargin{1}, 'double') ...
                            && 0 < varargin{1} && varargin{1} <= self.period
                temp = dict(varargin{1});           %plot the zone, contained in argument 1
                plot(temp(1, :), temp(2, :), '.', 'markersize', m, 'color', 'b');
                xlabel("x_n"); ylabel("x_n_+_1"); title("\alpha = " + self.a + ", \beta = " + self.b);
                grid on, box off, grid minor
                ylim([-1 1]);
                xlim([-1 1]);
                hold off
            elseif size(varargin, 2) > 1 && size(varargin, 2) <= self.period
                for i=1:1:size(varargin, 2)                 %plot zones in arguments
                    temp = dict(varargin{i});
                    plot(temp(1, :), temp(2, :), '.', 'markersize', m, 'color', 'b');
                    xlabel("x_n"); ylabel("x_n_+_1"); title("\alpha = " + self.a + ", \beta = " + self.b);
                    grid on, box off, grid minor
                    hold on;
                end
                ylim([-1 1]);
                xlim([-1 1]);
                hold off;                
            else
                error("The arguments are not valid");
            end
        end
        
        function zone = identify(self, point)
            % This function should return the zone, to which the given
            % point belongs. If the point does not belong to any zone, then
            % just return -1
            dict = self.groupZones(false);              % don't update initial conditions
            [temp, ~] = self.getSequence(false);         % don't update initial conditions
            [k, dist] = dsearchn([temp(1:end-1); temp(2:end)]',  point);

            if dist > 10^-3
                warning("The point (%d, %d) does not belong to any zone", point(1), point(2));
                zone = -1;
            else
                temp1 = [temp(1:end-1); temp(2:end)]';
                p_exact = temp1(k, :);
                for i=1:1:self.period                       % iterate through all zones, # of zones = period
                    if any(ismember(dict(i)', p_exact, 'rows'))
                        zone = i;
                        break
                    end
                end
            end
        end
        
        function [key, start_of_hopping] = getOrder(self, varargin)
            load('zone_clusters.mat', 'data');
            treshold_1 = 10^-6; treshold_2 = 10^-3;
            if size(varargin, 2) > 0 && isDataArray(varargin{1})
                self.x1 = varargin{1}(1);
                self.x2 = varargin{1}(2);
            end
            if size(varargin, 2) > 2 && isa(varargin{2}, 'double') && isa(varargin{3}, 'double')
                treshold_1 = varargin{2};       %precision of allignment with the first zone
                treshold_2 = varargin{3};       %precision of belongs to a zone
            end
            
            % This loop is meant to allign the pivot to CZ0
            for i=1:10^7
                x_next = self.transient(1, true);
                [~, dist] = dsearchn(data(1)',  x_next);     % allign the start of cycle to the CZ0
                if dist <= treshold_1
                    start_of_hopping = x_next;           % this point belongs to CZ0
                    key = num2str(0);
                    break
                end
            end
            
            for i=1:1:7
                x_next = self.transient(i, false);
                % this loop checks where the next point belongs, i.e. the
                % corresponding chaotic zone CZ(k)
                for k=1:1:self.period                       %iterate through all zones, # of zones = period
                    [~, dist] = dsearchn(data(k)',  x_next);
                    if dist <= treshold_2
                        key = append(key, num2str(k-1));          %append the next chaotic zone index
                        break
                    end
                end
            end
        end
        
        function [cypher_binary, cypher, cypher_d] = cypher(self, msg, varargin)
            %encode() encodes a decimal number with this non-linear model
            % SYNOPSIS: encode(message) takes binary number and returns binary cypher
            % ARGUMENTS: msg -- message to encode; 
            % varargin{1} --  offset, i.e. the lag
            % varargin{2} --  'v' for verbose
            if ( class(msg) == "string" || class(msg) == "char" || class(msg) == "double")
                binary_input = num2str(msg);
            else
                error("Check your input");
            end
            L = self.optimizeLength(length(binary_input));
            decimal_input = bin2dec(binary_input);
            base_transform = dec2base(decimal_input, self.period);
            
            %теперь нужно определить порядок следования зон
            %я не знаю как определить порядок следования зон
            %[key, ~] = self.getOrder(0.1, 0.1);
            %key = '03614725';
            %key_order = key - '0';  % get index of zones into an array
            key_order = [0 5 10 2 7 12 4 9 1 6 11 3 8];
            digits = nan( 1, length(base_transform) );
            for i=1:1:length(base_transform)
                digits(i) = base2dec(base_transform(i), self.period);   %get individual digits of the number
            end
            
            if size(varargin, 2) > 0 && isa(varargin{1}, 'double')
                offset = varargin{1};  %we start with zone of offset
            else
                offset = 1;     %default start of coding for the first number
            end
            % The question is: how many iterations it will take to reach
            % from zone of offset to zone of each individual digit
            cypher = '';      %allocate memmory for enough cypher digits
            for s=1:1:length(digits)
                next_zone = mod(offset, length(key_order));
                if next_zone == 0
                    next_zone = length(key_order);
                end
                for i=0:1:length(key_order)
                    if next_zone == 0
                        next_zone = 1;
                    end
                    if key_order(next_zone) == digits(s)
                        cypher = append( cypher, dec2base(mod(i, length(key_order)), self.period) );
                        break
                    end
                    next_zone = mod(next_zone, length(key_order));
                    next_zone = next_zone + 1;
                end
            end
            cypher_d = base2dec(cypher, self.period);
            cypher_binary = dec2bin(cypher_d, L);
            if size(varargin, 2) > 1 && isa(varargin{2}, 'char') && varargin{2} == 'v'
                fprintf("Encoded message base_%d   = %s\nEncoded message base_2  = %s\n", self.period, cypher, cypher_binary);            
            end
        end
        
        function [msg_bin, msg] = decode(self, cypher, varargin)
            %decode(cypher, k) decodes an encrypted message
            % decodes a message using initial zone position k and cypher
            if ( class(cypher) == "string" || class(cypher) == "char" || class(cypher) == "double")
                bincypher = num2str(cypher);
                temp = bin2dec(bincypher);
                temp = dec2base(temp, self.period);
                L = length(bincypher);
                base_transform = temp;
            else
                error("Check your input");
            end
                        %теперь нужно определить порядок следования зон
            [key, ~] = self.getOrder(0.1, 0.1);
            key_order = key - '0';  % get index of zones into an array
            digits = base_transform - '0';  %get individual digits of the number
            
            if size(varargin, 2) >= 1 && isa(varargin{1}, 'double')
                offset = varargin{1};  %we start with zone of offset
            else
                offset = 1;     %default start of coding for the first number
            end
            
            msg = '';      %allocate memmory for enough cypher digits
            % The question is what zone I will wind up at after I iterate
            % the number of times indicated by each individual digit
            for i=1:1:length(digits)
                dest_zone = mod(offset + digits(i), length(key_order));
                if dest_zone == 0
                    dest_zone = length(key_order);
                end
                msg = append(msg, num2str(  key_order(dest_zone)  ));
            end
            msg_decimal = base2dec(msg, self.period);
            msg_bin = dec2bin(msg_decimal, L);
            if size(varargin, 2) > 1 && isa(varargin{2}, 'char') && varargin{2} == 'v'
                fprintf("Decoded message base_%d   = %s\nDecoded message base_2  = %s\n", self.period, msg, msg_bin);
            end
        end
        
        function L_new = optimizeLength(self, L)
            % determine optimal length of message
            N = self.period;
            if L > 1
                L_new = ceil(log2(N^ceil( log10(2^L-1)/log10(N) )-1));
            else
                L_new = nextpow2(N);
            end
        end
%% end of methods implementation        
        
    end
    
    
end
