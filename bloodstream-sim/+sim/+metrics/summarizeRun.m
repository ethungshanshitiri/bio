function summary = summarizeRun(observables, cfg)
summary = struct();
summary.detectionLatency_s = sim.metrics.computeDetectionLatency(observables);
summary.falseAlarmRate_Hz = sim.metrics.computeFalseAlarmRate(observables, cfg.tEnd);
summary.finalOccupancy = observables.occupancy(end);
summary.meanAnalog = mean(observables.analog);
end
