function field = applySourcesAndDecay(field, cfg, dt)
field.concentration = field.concentration + cfg.biomarkerSource*dt;
field.concentration = field.concentration .* exp(-cfg.biomarkerDecayRate*dt);
field.concentration = max(field.concentration, 0);
end
