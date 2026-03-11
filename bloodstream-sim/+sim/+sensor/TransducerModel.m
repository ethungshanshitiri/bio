function analog = TransducerModel(occ, ns, cfg, rngStream)
frac = (occ + 0.2*ns) / cfg.receptorCount;
analog = frac + cfg.noiseSigma * randn(rngStream,1);
analog = max(analog, 0);
end
