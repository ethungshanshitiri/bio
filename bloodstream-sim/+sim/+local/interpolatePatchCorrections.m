function corr = interpolatePatchCorrections(patchOutput, nSegments)
corr = patchOutput.correction;
if numel(corr) ~= nSegments
    error('Patch correction length mismatch.');
end
corr = corr(:);
end
