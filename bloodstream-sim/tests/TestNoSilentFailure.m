classdef TestNoSilentFailure < matlab.unittest.TestCase
    methods(Test)
        function noBroadTryCatch(testCase)
            root = fileparts(fileparts(mfilename('fullpath')));
            files = [dir(fullfile(root, '+sim', '**', '*.m')); dir(fullfile(root, 'tests', '*.m'))];
            token = ['ca' 'tch'];
            for i = 1:numel(files)
                p = fullfile(files(i).folder, files(i).name);
                if endsWith(p, 'TestNoSilentFailure.m')
                    continue;
                end
                txt = fileread(p);
                testCase.verifyFalse(contains(txt, token), sprintf('Forbidden try/catch token in %s', p));
            end
        end
    end
end
