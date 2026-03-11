function run_all_tests()
startup();
import matlab.unittest.TestSuite
suite = TestSuite.fromFolder(fullfile(fileparts(mfilename('fullpath')), 'tests'), 'IncludingSubfolders', true);
results = run(suite);
assert(all([results.Passed]), 'Some tests failed.');
fprintf('All tests passed: %d tests.\n', numel(results));
end
