classdef TestGraphValidation < matlab.unittest.TestCase
    methods(Test)
        function catchesBadConnectivity(testCase)
            cfg = sim.buildDefaultConfig();
            cfg.network.fromNode = [1 2 4];
            cfg.network.toNode = [2 3 5];
            g = sim.network.VascularGraph.fromConfig(cfg.network);
            testCase.verifyError(@() sim.network.validateGraph(g), 'sim:network:BadInlet');
        end
    end
end
