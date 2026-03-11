classdef Junction
    properties
        id double = 1
        incoming double = []
        outgoing double = []
    end
    methods
        function obj = Junction(id, incoming, outgoing)
            if nargin == 0
                return;
            end
            obj.id = id;
            obj.incoming = incoming;
            obj.outgoing = outgoing;
        end
    end
end
