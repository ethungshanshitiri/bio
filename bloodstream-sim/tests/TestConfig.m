classdef TestConfig < matlab.unittest.TestCase
    methods(Test)
        function validConfig(testCase)
            cfg = sim.buildDefaultConfig();
            testCase.verifyWarningFree(@() sim.utils.assertValidConfig(cfg));
        end
    end
end
