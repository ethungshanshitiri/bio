function rate = computeFalseAlarmRate(observables, tEnd)
rate = observables.falseAlarms / max(tEnd, eps);
end
