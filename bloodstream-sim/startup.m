function startup()
% Add project root so package +sim is resolvable.
root = fileparts(mfilename('fullpath'));
addpath(root);
fprintf('bloodstream-sim startup complete.\n');
end
