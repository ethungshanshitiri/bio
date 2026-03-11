classdef Observables
    properties
        occupancy double
        analog double
        decision logical
        falseAlarms double
        agentSegment double
        detectionLatency double
    end
    methods
        function obj = Observables(nSteps, ~, nAgents)
            obj.occupancy = zeros(1, nSteps);
            obj.analog = zeros(1, nSteps);
            obj.decision = false(1, nSteps);
            obj.falseAlarms = 0;
            obj.agentSegment = zeros(nAgents, nSteps);
            obj.detectionLatency = NaN;
        end
    end
end
