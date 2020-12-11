classdef Position
    %POSITION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        delT         % Time step
        sigp         % Position measurement noise
        siga         % Acceleration measurement noise
    end
    
    methods
        function [A,B,H,P,Q,R] = createFiltObj(obj)
            A = [1,  obj.delT, -T^2/2;
                 0,  1,        -T;
                 0,  0,         1];
            B = [T^2/2; 
                 T; 
                 0];
            H = [1, 0, 0];
            Q = [(T^4/4)*obj.sigp^2, (T^3/2)*obj.sigp^2,   -T^2/2;
                 (T^3/2)*obj.sigp^2,  T^2*obj.sigp^2,       0;
                 0,               0,                1];
            R = obj.siga;
            P = eye(3);
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

