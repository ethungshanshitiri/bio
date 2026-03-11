classdef Config
    properties
        dt double
        tEnd double
        seed double
        numAgents double
        enableWallBias logical
        wallBiasFactor double
        agentDiffusivity double
        agentEnergyPerStep double
        bloodDensity double
        bloodViscosity double
        inletFlowMean double
        inletFlowAmp double
        pulseFreqHz double
        biomarkerDiffusivity double
        biomarkerDecayRate double
        biomarkerSource double
        receptorCount double
        kOn double
        kOff double
        kNonSpecific double
        noiseSigma double
        decisionThreshold double
        falseAlarmThresholdSigma double
        useParallel logical
        network struct
    end
    methods
        function obj = Config(s)
            f = fieldnames(s);
            for i = 1:numel(f)
                obj.(f{i}) = s.(f{i});
            end
        end
    end
end
