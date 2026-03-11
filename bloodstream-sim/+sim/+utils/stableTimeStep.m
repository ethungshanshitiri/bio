function dt = stableTimeStep(length_m, velocity, diffusivity)
adv = sim.utils.safeDivide(length_m, max(abs(velocity), eps), inf);
dif = sim.utils.safeDivide(length_m^2, 2*max(diffusivity, eps), inf);
dt = 0.5 * min(adv, dif);
end
