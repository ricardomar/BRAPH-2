classdef ComparisonfMRI < Comparison
    properties
        value_1  % array with the value_1 of the measure for each subject of group 1
        value_2  % array with the value_1 of the measure for each subject of group 1
        average_value_1  % average value of group 1
        average_value_2  % average value of group 1
        difference  % difference between the mean of the values
        all_differences  % all differences obtained through the permutation test
        p1  % p value single tailed
        p2  % p value double tailed
        confidence_interval_min  % min value of the 95% confidence interval
        confidence_interval_max  % max value of the 95% confidence interval
    end
    methods  % Constructor
        function c =  ComparisonfMRI(id, label, notes, atlas, measure_code, group_1, group_2, varargin)
            
            graph_type = AnalysisfMRI.getGraphType();
            measure_list = Graph.getCompatibleMeasureList(graph_type);
            
            assert(ismember(measure_code, measure_list), ...
                [BRAPH2.STR ':ComparisonfMRI:' BRAPH2.BUG_FUNC], ...
                'ComparisonfMRI measure_code is not compatible with the permited Measures.');
            
            
            c = c@Comparison(id, label, notes, atlas, measure_code, group_1, group_2, varargin{:});
        end
    end
    methods  % Get functions
        function [value_1, value_2] = getGroupValues(c)
            value_1 = c.value_1;
            value_2 = c.value_2;
        end
        function value = getGroupValue(c, group_index)
            if group_index == 1
                value = c.value_1;
            else
                value = c.value_2;
            end
        end
        function [average_value_1, average_value_2] = getGroupAverageValues(c)
            average_value_1 = c.average_value_1;
            average_value_2 = c.average_value_2;
        end
        function average_value = getGroupAverageValue(c, group_index)
            if group_index == 1
                average_value = c.average_value_1;
            else
                average_value = c.average_value_2;
            end
        end
        function difference = getDifference(c)
            difference = c.difference;
        end
        function all_differences = getAllDifferences(c)
            all_differences = c.all_differences;
        end
        function p1 = getP1(c)
            p1 = c.p1;
        end
        function p2 = getP2(c)
            p2 = c.p2;
        end
        function confidence_interval_min = getConfidenceIntervalMin(c)
            confidence_interval_min = c.confidence_interval_min;
        end
        function confidence_interval_max = getConfidenceIntervalMax(c)
            confidence_interval_max = c.confidence_interval_max;
        end
    end
    methods (Access=protected)  % Initialize data
        function initialize_data(c, varargin)
            atlases = c.getBrainAtlases();
            atlas = atlases{1};
            [group1, group2] = c.getGroups();
            
            measure_code = c.getMeasureCode();
            
            number_of_permutations = c.getSettings('ComparisonfMRI.PermutationNumber');
            
            if Measure.is_global(measure_code)  % global measure
                % values
                c.value_1 = get_from_varargin( ...
                    repmat({0}, 1, group1.subjectnumber()), ...
                    'ComparisonfMRI.value_1', ...
                    varargin{:});
                assert(iscell(c.getGroupValue(1)) & ...
                    isequal(size(c.getGroupValue(1)), [1, group1.subjectnumber()]) & ...
                    all(cellfun(@(x) isequal(size(x), [1, 1]), c.getGroupValue(1))), ...
                    ['BRAPH:ComparisonfMRI:WrongData'], ...
                    ['Data not compatible with ComparisonfMRI.'])
                
                c.value_2 = get_from_varargin( ...
                    repmat({0}, 1, group2.subjectnumber()), ...
                    'ComparisonfMRI.value_2', ...
                    varargin{:});
                assert(iscell(c.getGroupValue(2)) & ...
                    isequal(size(c.getGroupValue(2)), [1, group2.subjectnumber()]) & ...
                    all(cellfun(@(x) isequal(size(x), [1, 1]), c.getGroupValue(2))), ...
                    ['BRAPH:ComparisonfMRI:WrongData'], ...
                    ['Data not compatible with ComparisonfMRI.'])
                
                % average values
                c.average_value_1 = get_from_varargin( ...
                    {0}, ...
                    'ComparisonfMRI.average_value_1', ...
                    varargin{:});
                assert(iscell(c.getGroupAverageValue(1)) && ...
                    isequal(size(c.getGroupAverageValue(1)), [1, 1]) && ...
                    all(cellfun(@(x) isequal(size(x), [1, 1]), c.getGroupAverageValue(1))), ...
                    [BRAPH2.STR ':ComparisonfMRI:' BRAPH2.WRONG_INPUT], ...
                    'Data not compatible with ComparisonfMRI')
                
                c.average_value_2 = get_from_varargin( ...
                    {0}, ...
                    'ComparisonfMRI.average_value_2', ...
                    varargin{:});
                assert(iscell(c.getGroupAverageValue(2)) && ...
                    isequal(size(c.getGroupAverageValue(2)), [1, 1]) && ...
                    all(cellfun(@(x) isequal(size(x), [1, 1]), c.getGroupAverageValue(2))), ...
                    [BRAPH2.STR ':ComparisonfMRI:' BRAPH2.WRONG_INPUT], ...
                    'Data not compatible with ComparisonfMRI')
                
                % statistic measures
                c.difference = get_from_varargin( ...
                    {0}, ...
                    'ComparisonfMRI.difference', ...
                    varargin{:});
                assert(iscell(c.getDifference()) && ...
                    isequal(size(c.getDifference()), [1, 1]) && ...
                    all(cellfun(@(x) isequal(size(x), [1, 1]), c.getDifference())), ...
                    [BRAPH2.STR ':ComparisonfMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonfMRI')
                
                c.all_differences = get_from_varargin( ...
                    repmat({0}, 1, number_of_permutations), ...
                    'ComparisonfMRI.all_differences', ...
                    varargin{:});
                assert(iscell(c.getAllDifferences()) && ...
                    isequal(size(c.getAllDifferences()), [1, number_of_permutations]) && ...
                    all(cellfun(@(x) isequal(size(x), [1, 1]), c.getAllDifferences())), ...
                    [BRAPH2.STR ':ComparisonfMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonfMRI')
                
                c.p1 = get_from_varargin( ...
                    {0}, ...
                    'ComparisonfMRI.p1', ...
                    varargin{:});
                assert(iscell(c.getP1()) && ...
                    isequal(size(c.getP1()), [1, 1]) && ...
                    all(cellfun(@(x) isequal(size(x), [1, 1]), c.getP1())), ...
                    [BRAPH2.STR ':ComparisonfMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonfMRI')
                
                c.p2 = get_from_varargin( ...
                    {0}, ...
                    'ComparisonfMRI.p2', ...
                    varargin{:});
                assert(iscell(c.getP2()) && ...
                    isequal(size(c.getP2()), [1, 1]) && ...
                    all(cellfun(@(x) isequal(size(x), [1, 1]), c.getP2())), ...
                    [BRAPH2.STR ':ComparisonfMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonfMRI')
                
                c.confidence_interval_min = get_from_varargin( ...
                    {0}, ...
                    'ComparisonfMRI.confidence_min', ...
                    varargin{:});
                assert(iscell(c.getConfidenceIntervalMin()) && ...
                    isequal(size(c.getConfidenceIntervalMin()), [1, 1]) && ...
                    all(cellfun(@(x) isequal(size(x), [1, 1]), c.getConfidenceIntervalMin())), ...
                    [BRAPH2.STR ':ComparisonfMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonfMRI')
                
                c.confidence_interval_max = get_from_varargin( ...
                    {0}, ...
                    'ComparisonfMRI.confidence_max', ...
                    varargin{:});
                assert(iscell(c.getConfidenceIntervalMax()) && ...
                    isequal(size(c.getConfidenceIntervalMax()), [1, 1]) && ...
                    all(cellfun(@(x) isequal(size(x), [1, 1]), c.getConfidenceIntervalMax())), ...
                    [BRAPH2.STR ':ComparisonfMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonfMRI')
                
            elseif Measure.is_nodal(measure_code)  % nodal measure
                c.value_1 = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length(), 1)}, 1, group1.subjectnumber()), ...
                    'ComparisonfMRI.value_1', ...
                    varargin{:});
                assert(iscell(c.getGroupValue(1)) & ...
                    isequal(size(c.getGroupValue(1)), [1, group1.subjectnumber()]) & ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), c.getGroupValue(1))), ...
                    ['BRAPH:ComparisonfMRI:WrongData'], ...
                    ['Data not compatible with ComparisonfMRI.'])
                
                c.value_2 = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length(), 1)}, 1, group2.subjectnumber()), ...
                    'ComparisonfMRI.value_2', ...
                    varargin{:});
                assert(iscell(c.getGroupValue(2)) & ...
                    isequal(size(c.getGroupValue(2)), [1, group2.subjectnumber()]) & ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), c.getGroupValue(2))), ...
                    ['BRAPH:ComparisonfMRI:WrongData'], ...
                    ['Data not compatible with ComparisonfMRI.'])
                
                c.average_value_1 = get_from_varargin( ...
                    {zeros(atlas.getBrainRegions().length(), 1)}, ...
                    'ComparisonfMRI.average_value_1', ...
                    varargin{:});
                assert(iscell(c.getGroupAverageValue(1)) && ...
                    isequal(size(c.getGroupAverageValue(1)), [1, 1]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), c.getGroupAverageValue(1))), ...
                    [BRAPH2.STR ':ComparisonfMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonfMRI')
                
                c.average_value_2 = get_from_varargin( ...
                    {zeros(atlas.getBrainRegions().length(), 1)}, ...
                    'ComparisonfMRI.average_value_2', ...
                    varargin{:});
                assert(iscell(c.getGroupAverageValue(2)) && ...
                    isequal(size(c.getGroupAverageValue(2)), [1, 1]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), c.getGroupAverageValue(2))), ...
                    [BRAPH2.STR ':ComparisonfMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonfMRI')
                
                % statistic values
                c.difference = get_from_varargin( ...
                    {zeros(atlas.getBrainRegions().length(), 1)}, ...
                    'ComparisonfMRI.difference', ...
                    varargin{:});
                assert(iscell(c.getDifference()) && ...
                    isequal(size(c.getDifference()), [1, 1]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), c.getDifference())), ...
                    [BRAPH2.STR ':ComparisonfMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonfMRI')
                
                c.all_differences = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length(), 1)}, 1, number_of_permutations), ...
                    'ComparisonfMRI.all_differences', ...
                    varargin{:});
                assert(iscell(c.getAllDifferences()) && ...
                    isequal(size(c.getAllDifferences()), [1, number_of_permutations]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), c.getAllDifferences())), ...
                    [BRAPH2.STR ':ComparisonfMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonfMRI')
                
                c.p1 = get_from_varargin( ...
                    {zeros(atlas.getBrainRegions().length(), 1)}, ...
                    'ComparisonfMRI.p1', ...
                    varargin{:});
                assert(iscell(c.getP1()) && ...
                    isequal(size(c.getP1()), [1, 1]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), c.getP1())), ...
                    [BRAPH2.STR ':ComparisonfMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonfMRI')
                
                c.p2 = get_from_varargin( ...
                    {zeros(atlas.getBrainRegions().length(), 1)}, ...
                    'ComparisonfMRI.p2', ...
                    varargin{:});
                assert(iscell(c.getP2()) && ...
                    isequal(size(c.getP2()), [1, 1]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), c.getP2())), ...
                    [BRAPH2.STR ':ComparisonfMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonfMRI')
                
                c.confidence_interval_min = get_from_varargin( ...
                    {zeros(atlas.getBrainRegions().length(), 1)}, ...
                    'ComparisonfMRI.confidence_min', ...
                    varargin{:});
                assert(iscell(c.getConfidenceIntervalMin()) && ...
                    isequal(size(c.getConfidenceIntervalMin()), [1, 1]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), c.getConfidenceIntervalMin())), ...
                    [BRAPH2.STR ':ComparisonfMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonfMRI')
                
                c.confidence_interval_max = get_from_varargin( ...
                    {zeros(atlas.getBrainRegions().length(), 1)}, ...
                    'ComparisonfMRI.confidence_max', ...
                    varargin{:});
                assert(iscell(c.getConfidenceIntervalMax()) && ...
                    isequal(size(c.getConfidenceIntervalMax()), [1, 1]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), c.getConfidenceIntervalMax())), ...
                    [BRAPH2.STR ':ComparisonfMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonfMRI')
                
            elseif Measure.is_binodal(measure_code)  % binodal measure
                c.value_1 = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length())}, 1, group1.subjectnumber()), ...
                    'ComparisonfMRI.value_1', ...
                    varargin{:});
                assert(iscell(c.getGroupValue(1)) & ...
                    isequal(size(c.getGroupValue(1)), [1, group1.subjectnumber()]) & ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), c.getGroupValue(1))), ...
                    ['BRAPH:ComparisonfMRI:WrongData'], ...
                    ['Data not compatible with ComparisonfMRI.']) %#ok<*NBRAK>
                
                c.value_2 = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length())}, 1, group2.subjectnumber()), ...
                    'ComparisonfMRI.value_2', ...
                    varargin{:});
                assert(iscell(c.getGroupValue(2)) & ...
                    isequal(size(c.getGroupValue(2)), [1, group2.subjectnumber()]) & ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), c.getGroupValue(2))), ...
                    ['BRAPH:ComparisonfMRI:WrongData'], ...
                    ['Data not compatible with ComparisonfMRI.'])
                
                c.average_value_1 = get_from_varargin( ...
                    {zeros(atlas.getBrainRegions().length())}, ...
                    'ComparisonfMRI.average_value_1', ...
                    varargin{:});
                assert(iscell(c.getGroupAverageValue(1)) && ...
                    isequal(size(c.getGroupAverageValue(1)), [1, 1]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), c.getGroupAverageValue(1))), ...
                    [BRAPH2.STR ':ComparisonfMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonfMRI')
                
                c.average_value_2 = get_from_varargin( ...
                    {zeros(atlas.getBrainRegions().length())}, ...
                    'ComparisonfMRI.average_value_2', ...
                    varargin{:});
                assert(iscell(c.getGroupAverageValue(2)) && ...
                    isequal(size(c.getGroupAverageValue(2)), [1, 1]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), c.getGroupAverageValue(2))), ...
                    [BRAPH2.STR ':ComparisonfMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonfMRI')
                
                
                % statistic values
                c.difference = get_from_varargin( ...
                    {zeros(atlas.getBrainRegions().length())}, ...
                    'ComparisonfMRI.difference', ...
                    varargin{:});
                assert(iscell(c.getDifference()) && ...
                    isequal(size(c.getDifference()), [1, 1]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), c.getDifference())), ...
                    [BRAPH2.STR ':ComparisonfMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonfMRI')
                
                c.all_differences = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length())}, 1, number_of_permutations), ...
                    'ComparisonfMRI.all_differences', ...
                    varargin{:});
                assert(iscell(c.getAllDifferences()) && ...
                    isequal(size(c.getAllDifferences()), [1, number_of_permutations]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), c.getAllDifferences())), ...
                    [BRAPH2.STR ':ComparisonfMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonfMRI')
                
                c.p1 = get_from_varargin( ...
                    {zeros(atlas.getBrainRegions().length())}, ...
                    'ComparisonfMRI.p1', ...
                    varargin{:});
                assert(iscell(c.getP1()) && ...
                    isequal(size(c.getP1()), [1, 1]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), c.getP1())), ...
                    [BRAPH2.STR ':ComparisonfMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonfMRI')
                
                c.p2 = get_from_varargin( ...
                    {zeros(atlas.getBrainRegions().length())}, ...
                    'ComparisonfMRI.p2', ...
                    varargin{:});
                assert(iscell(c.getP2()) && ...
                    isequal(size(c.getP2()), [1, 1]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), c.getP2())), ...
                    [BRAPH2.STR ':ComparisonfMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonfMRI')
                
                c.confidence_interval_min = get_from_varargin( ...
                    {zeros(atlas.getBrainRegions().length())}, ...
                    'ComparisonfMRI.confidence_min', ...
                    varargin{:});
                assert(iscell(c.getConfidenceIntervalMin()) && ...
                    isequal(size(c.getConfidenceIntervalMin()), [1, 1]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), c.getConfidenceIntervalMin())), ...
                    [BRAPH2.STR ':ComparisonfMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonfMRI')
                
                c.confidence_interval_max = get_from_varargin( ...
                    {zeros(atlas.getBrainRegions().length())}, ...
                    'ComparisonfMRI.confidence_max', ...
                    varargin{:});
                assert(iscell(c.getConfidenceIntervalMax()) && ...
                    isequal(size(c.getConfidenceIntervalMax()), [1, 1]) && ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), c.getConfidenceIntervalMax())), ...
                    [BRAPH2.STR ':ComparisonfMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonfMRI')
            end
        end
    end
    methods (Static)  % Descriptive functions
        function class = getClass()
            class = 'ComparisonfMRI';
        end
        function name = getName()
            name = 'Comparison Functional MRI';
        end
        function description = getDescription()
            description = 'fMRI comparison.';
        end
        function atlas_number = getBrainAtlasNumber()
            atlas_number =  1;
        end
        function analysis_class = getAnalysisClass()
            analysis_class = 'AnalysisfMRI';
        end
        function subject_class = getSubjectClass()
            subject_class = 'SubjectfMRI';
        end
        function available_settings = getAvailableSettings()
            available_settings = {
                'ComparisonfMRI.PermutationNumber', BRAPH2.NUMERIC, 1000, {};
                };
        end
        function sub = getComparison(comparisonClass, id, label, notes, atlas, measure_code, group_1, group_2, varargin) %#ok<INUSD>
            sub = eval([comparisonClass '(id, label, notes, atlas, mesure_code, group_1, group_2, varargin{:})']);
        end
    end
end