function agents = updateEnergyState(agents, cfg, dt)
consumed = cfg.agentEnergyPerStep * dt;
agents.energy = max(0, agents.energy - consumed);
end
