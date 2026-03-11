function validateGraph(graph)
seg = graph.segments;
if isempty(seg)
    error('sim:network:EmptyGraph','Vascular graph must contain at least one segment.');
end
for i = 1:numel(seg)
    if seg(i).length_m <= 0 || seg(i).diameter_m <= 0
        error('sim:network:BadGeometry','Segment %d has nonpositive geometry.', i);
    end
end
from = [seg.fromNode];
to = [seg.toNode];
inletNodes = setdiff(unique(from), unique(to));
outletNodes = setdiff(unique(to), unique(from));
if numel(inletNodes) ~= 1
    error('sim:network:BadInlet','Graph must have exactly one inlet node.');
end
if isempty(outletNodes)
    error('sim:network:BadOutlet','Graph must have at least one outlet node.');
end
end
