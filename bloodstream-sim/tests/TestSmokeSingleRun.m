classdef TestSmokeSingleRun < matlab.unittest.TestCase
    methods(Test)
        function runTinyBifurcationAndDeterministic(testCase)
            cfg = sim.buildDefaultConfig();
            cfg.tEnd = 0.2;
            out1 = sim.runSimulation(cfg);
            out2 = sim.runSimulation(cfg);
            testCase.verifyEqual(out1.summary.finalOccupancy, out2.summary.finalOccupancy, 'AbsTol', 1e-12);
        end
    end
end
