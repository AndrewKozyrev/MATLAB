classdef CCA
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
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
        function obj = CCA(in_a, in_b, in_x1, in_x2, in_period)
            %CCA Construct an instance of this class
            %   Detailed explanation goes here
            obj.a = in_a;
            obj.b = in_b;
            obj.x1 = in_x1;
            obj.x2 = in_x2;
            obj.period = in_period;
            obj.transient_count = 10^7;
            obj.sequence_length = 10^6;
        end
        
        function drawBorders(obj)
            %drawBorders draws grid alike borders over chaotic zones on the
            %phase plane
            %   Depending on period, this function iterates through all
            %   chaotic zones and plots borders for each
            n = obj.period;
            [x, y] = obj.getSequence();
            for i=1:n
                left = min(x(i:n:end-1)); 
                right = max(x(i:n:end-1)); 
                bottom = min(x(i+1:n:end)); 
                top = max(x(i+1:n:end));
                hold on
                plot([left left], [bottom top], 'r')
                plot([right right], [bottom top], 'r')
                plot([left right], [bottom bottom], 'r')
                plot([left right], [top top], 'r')
            end
        end
        
        function mapping = groupZones(obj)
            n = obj.period;
            [x, y] = obj.getSequence();
            mapping = containers.Map('KeyType','uint64','ValueType','any');
            for i=1:n
                mapping(i-1) = [x(i:n:end-1); x(i+1:n:end)];
            end
        end
        
        function [x, y] = getSequence(obj)
            %retrieves a sequence from chaotic system of equations
            M = obj.transient_count;
            N = obj.sequence_length;
            y = obj.a*obj.x2 + obj.b*obj.x1;
            % transient decay process
            for i=1:M
                x3 = sin( pi*y );
                obj.x1 = obj.x2;
                obj.x2 = x3;
                y = obj.a*obj.x2 + obj.b*obj.x1;
            end

            clear x y
            % recording cycle
            for j=1:N
                y(j) = obj.a*obj.x2 + obj.b*obj.x1;
                x3 = sin( pi*y(j) );
                obj.x1 = obj.x2;
                obj.x2 = x3;
                x(j) = x3;
            end

        end
    end
end

