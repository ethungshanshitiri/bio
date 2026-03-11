function out = runSimulation(cfg)
sim.utils.assertValidConfig(cfg);
state = sim.initializeSimulation(cfg);
for k = 1:state.nSteps
    t = state.time(k);
    [q, regime] = sim.network.solveGlobalFlow(state.graph, cfg, t);
    state.flow(:, k) = q;
    state.regime(:, k) = regime.label;

    patchOutput = state.patchManager.run(state.graph, regime, q, cfg, t);
    corr = sim.local.interpolatePatchCorrections(patchOutput, state.graph.numSegments());

    state.biomarker = sim.biomarkers.advanceField1D(state.biomarker, state.graph, q + corr, cfg, t);
    localIn = sim.biomarkers.sampleLocalMicrodomainInputs(state.biomarker, state.sensor.segmentId, cfg);
    state.sensor = sim.sensor.updateSensorState(state.sensor, localIn, cfg, state.dt, state.rng);

    state.agents = sim.agents.advanceAgents(state.agents, state.graph, q + corr, cfg, state.dt, state.rng);
    state.agents = sim.agents.updateEnergyState(state.agents, cfg, state.dt);

    state = sim.metrics.collectObservables(state, k);
end
out = sim.finalizeSimulation(state, cfg);
end
