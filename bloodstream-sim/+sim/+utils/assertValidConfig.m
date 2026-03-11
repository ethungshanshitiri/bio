function assertValidConfig(cfg)
req = {'dt','tEnd','numAgents','bloodDensity','bloodViscosity','network'};
for i = 1:numel(req)
    if ~isprop(cfg, req{i})
        error('Config missing required field: %s', req{i});
    end
end
if cfg.dt <= 0 || cfg.tEnd <= 0
    error('Config time settings must be positive.');
end
if cfg.numAgents < 1
    error('Config numAgents must be >= 1.');
end
if cfg.bloodDensity <= 0 || cfg.bloodViscosity <= 0
    error('Blood properties must be positive.');
end
end
