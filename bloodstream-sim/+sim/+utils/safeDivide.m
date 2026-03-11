function y = safeDivide(a, b, defaultVal)
if b == 0
    y = defaultVal;
else
    y = a / b;
end
end
