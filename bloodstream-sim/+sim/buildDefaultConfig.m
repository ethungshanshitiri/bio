function cfg = buildDefaultConfig()
cfgStruct.dt = 0.01;
cfgStruct.tEnd = 1.0;
cfgStruct.seed = 1234;
cfgStruct.numAgents = 40;
cfgStruct.enableWallBias = true;
cfgStruct.wallBiasFactor = 0.1;
cfgStruct.agentDiffusivity = 5e-11;
cfgStruct.agentEnergyPerStep = 1e-3;
cfgStruct.bloodDensity = 1060;
cfgStruct.bloodViscosity = 3.5e-3;
cfgStruct.inletFlowMean = 1.8e-6;
cfgStruct.inletFlowAmp = 0.3;
cfgStruct.pulseFreqHz = 1.2;
cfgStruct.biomarkerDiffusivity = 1e-10;
cfgStruct.biomarkerDecayRate = 0.2;
cfgStruct.biomarkerSource = 1e-3;
cfgStruct.receptorCount = 250;
cfgStruct.kOn = 4.0;
cfgStruct.kOff = 0.8;
cfgStruct.kNonSpecific = 0.02;
cfgStruct.noiseSigma = 0.02;
cfgStruct.decisionThreshold = 0.2;
cfgStruct.falseAlarmThresholdSigma = 2.0;
cfgStruct.useParallel = sim.utils.hasParallelToolbox();
cfgStruct.network = struct(...
    'length_m', [0.06 0.03 0.03], ...
    'diameter_m', [0.006 0.0035 0.003], ...
    'fromNode', [1 2 2], ...
    'toNode', [2 3 4], ...
    'curvature', [0.05 0.12 0.08], ...
    'stenosisSeverity', [0.0 0.15 0.08], ...
    'isMicrovessel', [false false true]);
cfg = sim.core.Config(cfgStruct);
end
