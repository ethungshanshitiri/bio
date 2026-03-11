classdef NanoMachineAgent
    methods(Static)
        function agents = initializeMany(n, graph, rngStream)
            agents.segmentId = ones(n,1);
            agents.position = zeros(n,1);
            agents.energy = ones(n,1);
            agents.wallClass = strings(n,1);
            agents.id = (1:n)';
            agents.rng = rngStream;
            if graph.numSegments() < 1
                error('Graph must include at least one segment.');
            end
        end
    end
end
