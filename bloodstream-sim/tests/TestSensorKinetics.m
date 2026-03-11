classdef TestSensorKinetics < matlab.unittest.TestCase
    methods(Test)
        function occupancyBounds(testCase)
            cfg = sim.buildDefaultConfig();
            rs = sim.utils.makeRngStream(7);
            s = sim.sensor.SensorModel(1, cfg.receptorCount);
            for k = 1:200
                s = sim.sensor.updateSensorState(s, 1e-2, cfg, cfg.dt, rs);
            end
            testCase.verifyGreaterThanOrEqual(s.occupancy, 0);
            testCase.verifyLessThanOrEqual(s.occupancy, cfg.receptorCount);
        end
    end
end
