function [occNext, nsNext] = ReceptorKinetics(occ, ns, cLocal, cfg, dt)
free = max(cfg.receptorCount - occ - ns, 0);
dOcc = cfg.kOn * cLocal * free - cfg.kOff * occ;
dNs = cfg.kNonSpecific * cLocal * free - 0.5*cfg.kOff*ns;
occNext = occ + dt*dOcc;
nsNext = ns + dt*dNs;
occNext = min(max(occNext, 0), cfg.receptorCount);
nsNext = min(max(nsNext, 0), cfg.receptorCount - occNext);
end
