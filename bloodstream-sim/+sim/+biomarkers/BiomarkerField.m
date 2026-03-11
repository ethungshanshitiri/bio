classdef BiomarkerField
    properties
        concentration double
    end
    methods
        function obj = BiomarkerField(nSegments, c0)
            obj.concentration = c0 * ones(nSegments,1);
        end
    end
end
