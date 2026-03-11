function state = initializeSimulation(cfg)
rngStream = sim.utils.makeRngStream(cfg.seed);
graph = sim.network.VascularGraph.fromConfig(cfg.network);
sim.network.validateGraph(graph);
time = 0:cfg.dt:cfg.tEnd;
state = sim.core.SimulationState(time, cfg, graph, rngStream);
state.patchManager = sim.local.PatchManager();
state.biomarker = sim.biomarkers.BiomarkerField(graph.numSegments(), cfg.biomarkerSource);
state.sensor = sim.sensor.SensorModel(2, cfg.receptorCount);
state.agents = sim.agents.NanoMachineAgent.initializeMany(cfg.numAgents, graph, rngStream);
end
