classdef TestBiomarkerField < matlab.unittest.TestCase
    methods(Test)
        function nonnegative(testCase)
            cfg = sim.buildDefaultConfig();
            g = sim.network.VascularGraph.fromConfig(cfg.network);
            field = sim.biomarkers.BiomarkerField(g.numSegments(), cfg.biomarkerSource);
            [q, ~] = sim.network.solveGlobalFlow(g, cfg, 0.1);
            for k = 1:20
                field = sim.biomarkers.advanceField1D(field, g, q, cfg, cfg.dt);
            end
            testCase.verifyGreaterThanOrEqual(min(field.concentration), 0);
        end
    end
end
