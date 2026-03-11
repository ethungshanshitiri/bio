classdef VascularGraph
    properties
        segments sim.network.VesselSegment
        junctions sim.network.Junction
    end
    methods(Static)
        function obj = fromConfig(net)
            n = numel(net.length_m);
            seg(n) = sim.network.VesselSegment();
            for i = 1:n
                seg(i) = sim.network.VesselSegment(i, net.fromNode(i), net.toNode(i), net.length_m(i), net.diameter_m(i), ...
                    net.curvature(i), net.stenosisSeverity(i), net.isMicrovessel(i));
            end
            nodeIds = unique([net.fromNode(:); net.toNode(:)])';
            j(numel(nodeIds)) = sim.network.Junction();
            for k = 1:numel(nodeIds)
                nid = nodeIds(k);
                inSeg = find(net.toNode == nid);
                outSeg = find(net.fromNode == nid);
                j(k) = sim.network.Junction(nid, inSeg, outSeg);
            end
            obj = sim.network.VascularGraph();
            obj.segments = seg;
            obj.junctions = j;
        end
    end
    methods
        function n = numSegments(obj)
            n = numel(obj.segments);
        end
        function outSeg = outgoingSegments(obj, nodeId)
            idx = find([obj.junctions.id] == nodeId, 1);
            if isempty(idx)
                outSeg = [];
            else
                outSeg = obj.junctions(idx).outgoing;
            end
        end
    end
end
