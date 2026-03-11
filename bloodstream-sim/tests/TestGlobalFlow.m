classdef TestGlobalFlow < matlab.unittest.TestCase
    methods(Test)
        function finiteFlow(testCase)
            cfg = sim.buildDefaultConfig();
            g = sim.network.VascularGraph.fromConfig(cfg.network);
            [q, regime] = sim.network.solveGlobalFlow(g, cfg, 0.1);
            testCase.verifyTrue(all(isfinite(q)));
            testCase.verifyEqual(numel(regime.label), g.numSegments());
        end
    end
end
