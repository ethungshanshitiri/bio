function corr = runTransitionalPatch(seg, q, ~, t)
scale = 0.03 * (1 + 0.1*sin(2*pi*t));
corr = -scale * seg.stenosisSeverity * q;
limit = 0.1 * abs(q);
corr = max(min(corr, limit), -limit);
end
