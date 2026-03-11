function out = selectPatches(graph, regime, q, cfg, t)
n = graph.numSegments();
out.correction = zeros(n,1);
for i = 1:n
    switch regime.label(i)
        case "microvascular_laminar"
            out.correction(i) = sim.local.runLaminarPatch(graph.segments(i), q(i), cfg, t);
        case "bulk_laminar"
            out.correction(i) = sim.local.runLaminarPatch(graph.segments(i), q(i), cfg, t);
        case "transitional_risk"
            out.correction(i) = sim.local.runTransitionalPatch(graph.segments(i), q(i), cfg, t);
        case "turbulent_patch_needed"
            out.correction(i) = sim.local.runTurbulentPatch(graph.segments(i), q(i), cfg, t);
        otherwise
            error('Unknown regime label: %s', regime.label(i));
    end
end
end
