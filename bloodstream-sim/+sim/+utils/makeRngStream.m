function s = makeRngStream(seed)
s = RandStream('mt19937ar', 'Seed', seed);
end
