function example_arch_patch()
startup();
cfg = sim.buildDefaultConfig();
cfg.network.curvature = [0.2 0.35 0.3];
cfg.network.stenosisSeverity = [0.1 0.25 0.2];
out = sim.runSimulation(cfg);
disp(out.summary);
end
