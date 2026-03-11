function regime = classifyFlowRegime(graph, q, cfg)
n = graph.numSegments();
labels = strings(n,1);
conf = zeros(n,1);
for i = 1:n
    seg = graph.segments(i);
    re = 4 * cfg.bloodDensity * abs(q(i)) / (pi * seg.diameter_m * cfg.bloodViscosity);
    geomRisk = 0.4*seg.curvature + 0.6*seg.stenosisSeverity;
    if seg.isMicrovessel || re < 300
        labels(i) = "microvascular_laminar";
        conf(i) = 0.95;
    elseif re < 1800 && geomRisk < 0.25
        labels(i) = "bulk_laminar";
        conf(i) = 0.85;
    elseif re < 2600 || geomRisk < 0.45
        labels(i) = "transitional_risk";
        conf(i) = 0.65;
    else
        labels(i) = "turbulent_patch_needed";
        conf(i) = 0.75;
    end
end
regime = struct('label', labels, 'confidence', conf);
end
