function cLocal = sampleLocalMicrodomainInputs(field, segmentId, ~)
cBulk = field.concentration(segmentId);
cLocal = sim.biomarkers.interpolateSurfaceConcentration(cBulk);
end
