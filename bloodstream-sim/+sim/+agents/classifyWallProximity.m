function c = classifyWallProximity(position, segLength)
edgeFrac = min(position, segLength-position) / max(segLength, eps);
if edgeFrac < 0.1
    c = "near_wall";
else
    c = "core";
end
end
