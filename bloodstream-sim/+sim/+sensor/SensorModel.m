classdef SensorModel
    properties
        segmentId double
        receptorCount double
        occupancy double
        nonspecific double
        analogSignal double
        binaryDecision logical
    end
    methods
        function obj = SensorModel(segmentId, receptorCount)
            obj.segmentId = segmentId;
            obj.receptorCount = receptorCount;
            obj.occupancy = 0;
            obj.nonspecific = 0;
            obj.analogSignal = 0;
            obj.binaryDecision = false;
        end
    end
end
