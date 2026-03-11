function field = advanceField1D(field, graph, flow, cfg, dt)
n = graph.numSegments();
c = field.concentration;
next = c;
for i = 1:n
    seg = graph.segments(i);
    v = sim.utils.safeDivide(flow(i), seg.area(), 0);
    pecletFlux = abs(v) * dt / seg.length_m;
    diffFlux = cfg.biomarkerDiffusivity * dt / (seg.length_m^2);
    loss = (pecletFlux + diffFlux + cfg.biomarkerDecayRate*dt) * c(i);
    gain = cfg.biomarkerSource * dt;
    next(i) = c(i) - loss + gain;
end
field.concentration = max(next, 0);
field = sim.biomarkers.applySourcesAndDecay(field, cfg, dt);
end
