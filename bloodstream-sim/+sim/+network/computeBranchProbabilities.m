function p = computeBranchProbabilities(graph, flow, nodeId)
outSeg = graph.outgoingSegments(nodeId);
if isempty(outSeg)
    p = [];
    return;
end
f = max(flow(outSeg), 0);
s = sum(f);
if s <= 0
    p = ones(size(f)) / numel(f);
else
    p = f / s;
end
end
