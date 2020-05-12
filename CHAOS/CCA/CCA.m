classdef CCA < handle
    %CCA class describes chaotic cyclic attractor
    %   methods: 
    % getSequence() :  returns [x y] sequence
    % groupZones() : returns groups of zones
    % drawBorders() : void, draws borders around zones
    % displayPortrait() : displays given zones: 'one' - particular zone, 'all' - all zones
    % identify() : returns the number of zone given point belongs to
    
    properties
        a
        b
        x1
        x2
        period
        transient_count
        sequence_length
    end
    
    methods
        function self = CCA(in_a, in_b, in_x1, in_x2, in_period, varargin)
            %CCA Construct an instance of this class
            %   Initialize all possible parameters
            self.a = in_a;
            self.b = in_b;
            self.x1 = in_x1;
            self.x2 = in_x2;
            self.period = in_period;
            self.transient_count = 10^4;
            self.sequence_length = 10^5;
            if size(varargin, 2) > 0
                self.sequence_length = varargin{1};
            end
            if size(varargin, 2) > 1
                self.transient_count = varargin{2};
            end
            if size(varargin, 2) > 2
                error("This function doesn't accept so much arguments.");
            end
        end
        
        function drawBorders(self, varargin)
            %drawBorders draws grid like borders over chaotic zones on the
            %phase plane
            %   Depending on period, this function iterates through all
            %   chaotic zones and plots borders for each
            dict = self.groupZones();
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
            elseif size(varargin, 2) > 1 && size(varargin, 2) < self.period
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
        
        function mapping = groupZones(self)
            n = self.period;
            [x, ~] = self.getSequence();
            mapping = containers.Map('KeyType','uint64','ValueType','any');
            for i=1:n
                mapping(i) = [x(i:n:end-1); x(i+1:n:end)];
            end
        end
        
        function [self, x, y] = getSequence(self, varargin)
            %retrieves a sequence from chaotic system of equations
            
            % declare local variables
            if size(varargin, 2) == 1 && isa(varargin{1}, 'double')
                M = varargin{1};
            else
                M = self.transient_count;
            end
            N = self.sequence_length;
            temp_x1 = self.x1;
            temp_x2 = self.x2;
            temp_a = self.a;
            temp_b = self.b;
            y = temp_a*temp_x2 + temp_b*temp_x1;
            % end of local variables declaration
            
            % transient decay process
            for i=1:M
                x3 = sin( pi*y );
                temp_x1 = temp_x2;
                temp_x2 = x3;
                y = temp_a*temp_x2 + temp_b*temp_x1;
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
            % update the initial condition variables
            self.CCA() = x(end-1);
            self.x2 = x(end);
        end
        
        function displayPortrait(self, varargin)
            dict = self.groupZones();
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
            elseif size(varargin, 2) > 1 && size(varargin, 2) < self.period
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
            dict = self.groupZones();
            [temp, ~] = self.getSequence(0);
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
                    end
                end
            end
        end
        
    end
    
end

