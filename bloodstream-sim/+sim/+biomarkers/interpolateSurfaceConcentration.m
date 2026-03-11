function cSurface = interpolateSurfaceConcentration(cBulk)
cSurface = 0.85 * cBulk;
cSurface = max(cSurface, 0);
end
