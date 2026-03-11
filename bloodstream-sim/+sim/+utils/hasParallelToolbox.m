function tf = hasParallelToolbox()
tf = ~isempty(ver('parallel'));
end
