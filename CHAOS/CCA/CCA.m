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
            dict = self.groupZones(true);
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
        
        function [new_x1, new_x2] = transient(self, M, varargin)
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
            if size(varargin, 2) == 1 && isa(varargin{1}, 'logical') && varargin{1}
                self.x1 = new_x1;
                self.x2 = new_x2;
            end
        end
        
        function displayPortrait(self, varargin)
            dict = self.groupZones(true);
            if size(varargin, 2) == 0
                for i=1:1:self.period
                    temp = dict(i);
                    plot(temp(1, :), temp(2, :), '.', 'markersize', 3, 'color', 'b');
                    hold on;
                end
                ylim([-1 1]);
                xlim([-1 1]);
                hold off;
            elseif size(varargin, 2) == 1 && isa(varargin{1}, 'double') ...
                            && 0 < varargin{1} && varargin{1} <= self.period
                temp = dict(fix(varargin{1}));   %in case somebody throws me a floating value:o)
                plot(temp(1, :), temp(2, :), '.', 'markersize', 3, 'color', 'b');
                ylim([-1 1]);
                xlim([-1 1]);
                hold off
            elseif size(varargin, 2) > 1 && size(varargin, 2) <= self.period
                for i=1:1:size(varargin, 2)
                    temp = dict(varargin{i});
                    plot(temp(1, :), temp(2, :), '.', 'markersize', 3, 'color', 'b');
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
            dict = self.groupZones(false);      % don't update initial conditions
            [temp, ~] = self.getSequence(true);      %update initial conditions
            [k, dist] = dsearchn([temp(1:end-1); temp(2:end)]',  point);

            if dist > 10^-3
                warning("The point (%d, %d) does not belong to any zone", point(1), point(2));
                zone = -1;
            else
                temp1 = [temp(1:end-1); temp(2:end)]';
                p_exact = temp1(k, :);
                for i=1:1:self.period                       %iterate through all zones, # of zones = period
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
                [temp_x1, temp_x2] = self.transient(1, true);
                [~, dist] = dsearchn(data(1)',  [temp_x1 temp_x2]);     % allign the start of cycle to the CZ0
                if dist <= treshold_1
                    start_of_hopping = [temp_x1 temp_x2];           % this point belongs to CZ0
                    key = string(1);
                    break
                end
            end
            
            for i=1:1:8
                [temp_x1, temp_x2] = self.transient(1, true);
                % this loop checks where the next point belongs, i.e. the
                % corresponding chaotic zone CZ(k)
                for k=1:1:self.period                       %iterate through all zones, # of zones = period
                    [~, dist] = dsearchn(data(k)',  [temp_x1 temp_x2]);
                    if dist <= treshold_2
                        key = key + string(k);          %append the next chaotic zone index
                        break
                    end
                end
            end
        end
        
        function encode(self, varargin)
            %encode() encodes a message with this non-linear model
            %   encode(message) takes message and returns cypther
            if size(varargin, 2) >= 1 && ( class(varargin{1}) == "string" || class(varargin{1}) == "char")
                binary_input = num2str(varargin{1});
                decimal_input = bin2dec(binary_input);
            else
                error("Check your input");
            end
            k = ceil(   log( 2^length(binary_input) )/log( self.period )   );
            base_transform = dec2base(decimal_input, self.period);
            
            %теперь нужно определить зону первой точки, а также порядок
            %следования зон
            [key, x0] = self.getOrder(0.001, 0.01);
            
        end
        
    end
end

