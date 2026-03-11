function newSegId = routeAgentsAtJunctions(currentSegId, graph, flow, rngStream)
nodeId = graph.segments(currentSegId).toNode;
outSeg = graph.outgoingSegments(nodeId);
if isempty(outSeg)
    newSegId = currentSegId;
    return;
end
p = sim.network.computeBranchProbabilities(graph, flow, nodeId);
r = rand(rngStream,1);
cs = cumsum(p);
idx = find(r <= cs, 1, 'first');
newSegId = outSeg(idx);
end
