function agents = advanceAgents(agents, graph, flow, cfg, dt, rngStream)
for i = 1:numel(agents.id)
    sid = agents.segmentId(i);
    seg = graph.segments(sid);
    v = sim.utils.safeDivide(flow(sid), seg.area(), 0);
    sigma = sqrt(2*cfg.agentDiffusivity*dt);
    dx = v*dt + sigma*randn(rngStream,1);
    if cfg.enableWallBias
        cls = sim.agents.classifyWallProximity(agents.position(i), seg.length_m);
        if cls == "near_wall"
            dx = dx * (1 - cfg.wallBiasFactor);
        end
    end
    newPos = agents.position(i) + dx;
    while newPos > seg.length_m
        newPos = newPos - seg.length_m;
        agents.segmentId(i) = sim.agents.routeAgentsAtJunctions(agents.segmentId(i), graph, flow, rngStream);
        sid = agents.segmentId(i);
        seg = graph.segments(sid);
    end
    agents.position(i) = max(0, min(newPos, seg.length_m));
    agents.wallClass(i,1) = sim.agents.classifyWallProximity(agents.position(i), seg.length_m);
end
end
