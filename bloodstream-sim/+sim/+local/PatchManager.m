classdef PatchManager
    methods
        function out = run(~, graph, regime, q, cfg, t)
            out = sim.local.selectPatches(graph, regime, q, cfg, t);
        end
    end
end
