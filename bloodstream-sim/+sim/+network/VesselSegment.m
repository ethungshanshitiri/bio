classdef VesselSegment
    properties
        id double = 1
        fromNode double = 1
        toNode double = 1
        length_m double = 1
        diameter_m double = 1e-3
        curvature double = 0
        stenosisSeverity double = 0
        isMicrovessel logical = false
    end
    methods
        function obj = VesselSegment(id, fromNode, toNode, len, dia, curv, stenosis, isMicro)
            if nargin == 0
                return;
            end
            obj.id = id;
            obj.fromNode = fromNode;
            obj.toNode = toNode;
            obj.length_m = len;
            obj.diameter_m = dia;
            obj.curvature = curv;
            obj.stenosisSeverity = stenosis;
            obj.isMicrovessel = logical(isMicro);
        end
        function a = area(obj)
            a = pi * (obj.diameter_m / 2)^2;
        end
    end
end
