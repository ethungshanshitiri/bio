function out = run_demo()
startup();
cfg = sim.buildDefaultConfig();
out = sim.runSimulation(cfg);
summary = sim.metrics.summarizeRun(out.state.observables, cfg);
disp(summary);
end
