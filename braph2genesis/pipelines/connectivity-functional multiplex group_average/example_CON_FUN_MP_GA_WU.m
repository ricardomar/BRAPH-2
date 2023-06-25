%EXAMPLE_CON_FUN_MP_GA_WU
% Script example pipeline CON FUN MP GA WU

clear variables %#ok<*NASGU>

%% Load BrainAtlas
im_ba = ImporterBrainAtlasXLS( ...
    'FILE', [fileparts(which('SubjectCON_FUN_MP')) filesep 'Example data CON_FUN_MP XLS' filesep 'atlas.xlsx'], ...
    'WAITBAR', true ...
    );

ba = im_ba.get('BA');

%% Load Groups of SubjectCON
im_gr1 = ImporterGroupSubjectCON_XLS( ...
    'DIRECTORY', [fileparts(which('SubjectCON_FUN_MP')) filesep 'Example data CON_FUN_MP XLS' filesep 'CON_FUN_MP_Group_1_XLS.CON'], ...
    'BA', ba, ...
    'WAITBAR', true ...
    );

gr1_CON = im_gr1.get('GR');

im_gr2 = ImporterGroupSubjectCON_XLS( ...
    'DIRECTORY', [fileparts(which('SubjectCON_FUN_MP')) filesep 'Example data CON_FUN_MP XLS' filesep 'CON_FUN_MP_Group_2_XLS.CON'], ...
    'BA', ba, ...
    'WAITBAR', true ...
    );

gr2_CON = im_gr2.get('GR');

%% Load Groups of SubjectFUN
im_gr1 = ImporterGroupSubjectFUN_XLS( ...
    'DIRECTORY', [fileparts(which('SubjectCON_FUN_MP')) filesep 'Example data CON_FUN_MP XLS' filesep 'CON_FUN_MP_Group_1_XLS.FUN'], ...
    'BA', ba, ...
    'WAITBAR', true ...
    );

gr1_FUN = im_gr1.get('GR');

im_gr2 = ImporterGroupSubjectFUN_XLS( ...
    'DIRECTORY', [fileparts(which('SubjectCON_FUN_MP')) filesep 'Example data CON_FUN_MP XLS' filesep 'CON_FUN_MP_Group_2_XLS.FUN'], ...
    'BA', ba, ...
    'WAITBAR', true ...
    );

gr2_FUN = im_gr2.get('GR');

%% Combine Groups of SubjectCON with Groups of SubjectFUN
co_gr1 = CombineGroups_CON_FUN_MP( ...
    'GR_CON', gr1_CON, ...
    'GR_FUN', gr1_FUN, ...
    'WAITBAR', true ...
    );

gr1 = co_gr1.get('GR_CON_FUN_MP');

co_gr2 = CombineGroups_CON_FUN_MP( ...
    'GR_CON', gr2_CON, ...
    'GR_FUN', gr2_FUN, ...
    'WAITBAR', true ...
    );

gr2 = co_gr2.get('GR_CON_FUN_MP');

%% Analysis CON FUN MP GA WU
a_WU1 = AnalyzeGroup_CON_FUN_MP_GA_WU( ...
    'GR', gr1 ...
    );

a_WU2 = AnalyzeGroup_CON_FUN_MP_GA_WU( ...
    'TEMPLATE', a_WU1, ...
    'GR', gr2 ...
    );

% measure calculation
g_WU1 = a_WU1.get('G');
degree_WU1 = g_WU1.get('MEASURE', 'Degree').get('M');
% % % wmpc_WU1 = g_WU1.get('MEASURE', 'WeightedMultiplexParticipation').get('M');
% % % wmpc_av_WU1 = g_WU1.get('MEASURE', 'WeightedMultiplexParticipationAv').get('M');
% % % wedgeov_WU1 = g_WU1.get('MEASURE', 'WeightedEdgeOverlap').get('M');

g_WU2 = a_WU2.get('G');
degree_WU2 = g_WU2.get('MEASURE', 'Degree').get('M');
% % % wmpc_WU2 = g_WU2.get('MEASURE', 'WeightedMultiplexParticipation').get('M');
% % % wmpc_av_WU2 = g_WU2.get('MEASURE', 'WeightedMultiplexParticipationAv').get('M');
% % % wedgeov_WU2 = g_WU2.get('MEASURE', 'WeightedEdgeOverlap').get('M');

% comparison
c_WU = CompareGroup( ...
    'P', 10, ...
    'A1', a_WU1, ...
    'A2', a_WU2, ...
    'WAITBAR', true, ...
    'VERBOSE', false, ...
    'MEMORIZE', true ...
    );

degree_WU_diff = c_WU.get('COMPARISON', 'Degree').get('DIFF');
degree_WU_p1 = c_WU.get('COMPARISON', 'Degree').get('P1');
degree_WU_p2 = c_WU.get('COMPARISON', 'Degree').get('P2');
degree_WU_cil = c_WU.get('COMPARISON', 'Degree').get('CIL');
degree_WU_ciu = c_WU.get('COMPARISON', 'Degree').get('CIU');

% % % wmpc_WU_diff = c_WU.get('COMPARISON', 'WeightedMultiplexParticipation').get('DIFF');
% % % wmpc_WU_p1 = c_WU.get('COMPARISON', 'WeightedMultiplexParticipation').get('P1');
% % % wmpc_WU_p2 = c_WU.get('COMPARISON', 'WeightedMultiplexParticipation').get('P2');
% % % wmpc_WU_cil = c_WU.get('COMPARISON', 'WeightedMultiplexParticipation').get('CIL');
% % % wmpc_WU_ciu = c_WU.get('COMPARISON', 'WeightedMultiplexParticipation').get('CIU');

% % % wmpc_av_WU_diff = c_WU.get('COMPARISON', 'WeightedMultiplexParticipationAv').get('DIFF');
% % % wmpc_av_WU_p1 = c_WU.get('COMPARISON', 'WeightedMultiplexParticipationAv').get('P1');
% % % wmpc_av_WU_p2 = c_WU.get('COMPARISON', 'WeightedMultiplexParticipationAv').get('P2');
% % % wmpc_av_WU_cil = c_WU.get('COMPARISON', 'WeightedMultiplexParticipationAv').get('CIL');
% % % wmpc_av_WU_ciu = c_WU.get('COMPARISON', 'WeightedMultiplexParticipationAv').get('CIU');

% % % wedgeov_WU_diff = c_WU.get('COMPARISON', 'WeightedEdgeOverlap').get('DIFF');
% % % wedgeov_WU_p1 = c_WU.get('COMPARISON', 'WeightedEdgeOverlap').get('P1');
% % % wedgeov_WU_p2 = c_WU.get('COMPARISON', 'WeightedEdgeOverlap').get('P2');
% % % wedgeov_WU_cil = c_WU.get('COMPARISON', 'WeightedEdgeOverlap').get('CIL');
% % % wedgeov_WU_ciu = c_WU.get('COMPARISON', 'WeightedEdgeOverlap').get('CIU');
