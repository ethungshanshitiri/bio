function out = finalizeSimulation(state, cfg)
summary = sim.metrics.summarizeRun(state.observables, cfg);
out = struct('state', state, 'summary', summary);
end
