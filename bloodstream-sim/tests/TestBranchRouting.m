classdef TestBranchRouting < matlab.unittest.TestCase
    methods(Test)
        function preservesAgentCount(testCase)
            cfg = sim.buildDefaultConfig();
            g = sim.network.VascularGraph.fromConfig(cfg.network);
            rs = sim.utils.makeRngStream(42);
            agents = sim.agents.NanoMachineAgent.initializeMany(20, g, rs);
            [flow, ~] = sim.network.solveGlobalFlow(g, cfg, 0.2);
            agents2 = sim.agents.advanceAgents(agents, g, flow, cfg, cfg.dt, rs);
            testCase.verifyEqual(numel(agents2.id), numel(agents.id));
        end
    end
end
