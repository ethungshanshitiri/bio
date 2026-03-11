function example_bifurcation()
startup();
cfg = sim.buildDefaultConfig();
out = sim.runSimulation(cfg);
disp(out.summary);
end
