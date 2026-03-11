function corr = runTurbulentPatch(seg, q, ~, t)
scale = 0.08 * (1 + 0.2*cos(2*pi*t));
corr = -scale * (0.5 + seg.curvature + seg.stenosisSeverity) * q;
limit = 0.2 * abs(q);
corr = max(min(corr, limit), -limit);
end
