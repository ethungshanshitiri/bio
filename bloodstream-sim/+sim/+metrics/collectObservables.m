function state = collectObservables(state, k)
obs = state.observables;
obs.occupancy(k) = state.sensor.occupancy;
obs.analog(k) = state.sensor.analogSignal;
obs.decision(k) = state.sensor.binaryDecision;
obs.agentSegment(:, k) = state.agents.segmentId;
if k > 1 && obs.decision(k) && state.time(k) < 0.2
    obs.falseAlarms = obs.falseAlarms + 1;
end
if isnan(obs.detectionLatency) && obs.decision(k)
    obs.detectionLatency = state.time(k);
end
state.observables = obs;
end
