classdef SimulationState
    properties
        time double
        dt double
        nSteps double
        graph sim.network.VascularGraph
        flow double
        regime string
        patchManager sim.local.PatchManager
        biomarker sim.biomarkers.BiomarkerField
        sensor sim.sensor.SensorModel
        agents struct
        observables sim.core.Observables
        rng
    end
    methods
        function obj = SimulationState(time, cfg, graph, rngStream)
            nSeg = graph.numSegments();
            obj.time = time;
            obj.dt = cfg.dt;
            obj.nSteps = numel(time);
            obj.graph = graph;
            obj.flow = zeros(nSeg, obj.nSteps);
            obj.regime = strings(nSeg, obj.nSteps);
            obj.observables = sim.core.Observables(obj.nSteps, nSeg, cfg.numAgents);
            obj.rng = rngStream;
        end
    end
end
