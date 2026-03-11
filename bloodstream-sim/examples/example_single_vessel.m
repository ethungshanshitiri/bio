function example_single_vessel()
startup();
cfg = sim.buildDefaultConfig();
cfg.network.fromNode = 1;
cfg.network.toNode = 2;
cfg.network.length_m = 0.05;
cfg.network.diameter_m = 0.004;
cfg.network.curvature = 0.01;
cfg.network.stenosisSeverity = 0.00;
cfg.network.isMicrovessel = false;
out = sim.runSimulation(cfg);
disp(out.summary);
end
