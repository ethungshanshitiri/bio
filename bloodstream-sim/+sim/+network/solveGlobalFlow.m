function [q, regime] = solveGlobalFlow(graph, cfg, t)
n = graph.numSegments();
q = zeros(n, 1);
inlet = cfg.inletFlowMean * (1 + cfg.inletFlowAmp * sin(2*pi*cfg.pulseFreqHz*t));
if inlet < 0
    error('Inlet flow became negative; revise pulsatility parameters.');
end
res = zeros(n,1);
for i = 1:n
    seg = graph.segments(i);
    r = seg.diameter_m/2;
    res(i) = 8 * cfg.bloodViscosity * seg.length_m / (pi * r^4);
end
if any(~isfinite(res) | res <= 0)
    error('Computed invalid segment resistance.');
end
rootNode = 1;
q = propagateFlow(graph, res, rootNode, inlet);
regime = sim.network.classifyFlowRegime(graph, q, cfg);
end

function q = propagateFlow(graph, res, nodeId, qIn)
n = graph.numSegments();
q = zeros(n,1);
outSeg = graph.outgoingSegments(nodeId);
if isempty(outSeg)
    return;
end
weights = 1 ./ res(outSeg);
weights = weights / sum(weights);
for k = 1:numel(outSeg)
    sid = outSeg(k);
    q(sid) = qIn * weights(k);
    childNode = graph.segments(sid).toNode;
    qChild = propagateFlow(graph, res, childNode, q(sid));
    q = q + qChild;
end
end
