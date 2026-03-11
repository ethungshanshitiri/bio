# Architecture

The simulator is organized as a MATLAB package rooted at `+sim`.

- `+sim/core`: immutable-like configuration and mutable simulation state containers.
- `+sim/network`: graph definition, validation, global flow, and regime classification.
- `+sim/local`: patch manager and bounded patch correction outputs.
- `+sim/agents`: nanomachine state updates and branch routing.
- `+sim/biomarkers`: graph-field advection-diffusion-reaction updates.
- `+sim/sensor`: receptor kinetics, transducer, and binary decision model.
- `+sim/metrics`: observables and summary statistics.
- `+sim/utils`: config assertions and shared numerics.

`sim.runSimulation` orchestrates initialization, time stepping, and finalization.
