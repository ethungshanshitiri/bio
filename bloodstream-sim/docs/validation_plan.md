# Validation plan

1. Unit tests for configuration and graph validation.
2. Unit tests for finite, bounded outputs in flow and sensor kinetics.
3. Unit tests for nonnegativity in biomarker transport.
4. Unit tests for branch routing mass conservation.
5. Determinism test under fixed RNG seed.
6. Smoke test for a bifurcation network with end-to-end run.
7. Source scan test to enforce no broad `try/catch` usage.
