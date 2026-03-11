function corr = runLaminarPatch(~, q, ~, ~)
corr = 0;
if ~isfinite(q)
    error('Laminar patch received non-finite flow.');
end
end
