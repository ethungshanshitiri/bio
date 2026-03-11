function sensor = updateSensorState(sensor, cLocal, cfg, dt, rngStream)
[occ, ns] = sim.sensor.ReceptorKinetics(sensor.occupancy, sensor.nonspecific, cLocal, cfg, dt);
sensor.occupancy = occ;
sensor.nonspecific = ns;
sensor.analogSignal = sim.sensor.TransducerModel(occ, ns, cfg, rngStream);
sensor.binaryDecision = sim.sensor.makeBinaryDecision(sensor.analogSignal, cfg.decisionThreshold);
end
