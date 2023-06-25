%EXAMPLE_CON_FUN_MP_BUD
% Script example pipeline CON FUN MP BUD

clear variables %#ok<*NASGU>

%% Load BrainAtlas
im_ba = ImporterBrainAtlasXLS('FILE', [fileparts(which('SubjectCON_FUN_MP')) filesep 'Example data CON_FUN_MP XLS' filesep 'atlas.xlsx'], ...
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

%% Analysis CON FUN MP BUD
densities = 5:5:15;

a_BUD1 = AnalyzeEnsemble_CON_FUN_MP_BUD( ...
    'GR', gr1, ...
    'DENSITIES', densities ...
    );

a_BUD2 = AnalyzeEnsemble_CON_FUN_MP_BUD( ...
    'TEMPLATE', a_BUD1, ...
    'GR', gr2, ...
    'DENSITIES', densities ...
    );

% measure calculation
degree_BUD1 = a_BUD1.get('MEASUREENSEMBLE', 'Degree').get('M');
degreeav_BUD1 = a_BUD1.get('MEASUREENSEMBLE', 'DegreeAv').get('M');
distance_BUD1 = a_BUD1.get('MEASUREENSEMBLE', 'Distance').get('M');
% % % multiplexparticipation_BUD1 = a_BUD1.get('MEASUREENSEMBLE', 'MultiplexParticipation').get('M');
% % % ovdegree_av_BUD1 = a_BUD1.get('MEASUREENSEMBLE', 'OverlappingDegreeAv').get('M');
% % % edgeov_BUD1 = a_BUD1.get('MEASUREENSEMBLE', 'EdgeOverlap').get('M');

degree_BUD2 = a_BUD2.get('MEASUREENSEMBLE', 'Degree').get('M');
degreeav_BUD2 = a_BUD2.get('MEASUREENSEMBLE', 'DegreeAv').get('M');
distance_BUD2 = a_BUD2.get('MEASUREENSEMBLE', 'Distance').get('M');
% % % multiplexparticipation_BUD2 = a_BUD2.get('MEASUREENSEMBLE', 'MultiplexParticipation').get('M');
% % % ovdegree_av_BUD2 = a_BUD2.get('MEASUREENSEMBLE', 'DegreeAv').get('M');
% % % edgeov_BUD2 = a_BUD2.get('MEASUREENSEMBLE', 'EdgeOverlap').get('M');

% comparison
c_BUD = CompareEnsemble( ...
    'P', 10, ...
    'A1', a_BUD1, ...
    'A2', a_BUD2, ...
    'WAITBAR', true, ...
    'VERBOSE', false, ...
    'MEMORIZE', true ...
    );

degree_BUD_diff = c_BUD.get('COMPARISON', 'Degree').get('DIFF');
degree_BUD_p1 = c_BUD.get('COMPARISON', 'Degree').get('P1');
degree_BUD_p2 = c_BUD.get('COMPARISON', 'Degree').get('P2');
degree_BUD_cil = c_BUD.get('COMPARISON', 'Degree').get('CIL');
degree_BUD_ciu = c_BUD.get('COMPARISON', 'Degree').get('CIU');

degreeav_BUD_diff = c_BUD.get('COMPARISON', 'DegreeAv').get('DIFF');
degreeav_BUD_p1 = c_BUD.get('COMPARISON', 'DegreeAv').get('P1');
degreeav_BUD_p2 = c_BUD.get('COMPARISON', 'DegreeAv').get('P2');
degreeav_BUD_cil = c_BUD.get('COMPARISON', 'DegreeAv').get('CIL');
degreeav_BUD_ciu = c_BUD.get('COMPARISON', 'DegreeAv').get('CIU');

distance_BUD_diff = c_BUD.get('COMPARISON', 'Distance').get('DIFF');
distance_BUD_p1 = c_BUD.get('COMPARISON', 'Distance').get('P1');
distance_BUD_p2 = c_BUD.get('COMPARISON', 'Distance').get('P2');
distance_BUD_cil = c_BUD.get('COMPARISON', 'Distance').get('CIL');
distance_BUD_ciu = c_BUD.get('COMPARISON', 'Distance').get('CIU');

% % % multiplexparticipation_BUD_diff = c_BUD.get('COMPARISON', 'MultiplexParticipation').get('DIFF');
% % % multiplexparticipation_BUD_p1 = c_BUD.get('COMPARISON', 'MultiplexParticipation').get('P1');
% % % multiplexparticipation_BUD_p2 = c_BUD.get('COMPARISON', 'MultiplexParticipation').get('P2');
% % % multiplexparticipation_BUD_cil = c_BUD.get('COMPARISON', 'MultiplexParticipation').get('CIL');
% % % multiplexparticipation_BUD_ciu = c_BUD.get('COMPARISON', 'MultiplexParticipation').get('CIU');

% % % ovdegree_av_BUD_diff = c_BUD.get('COMPARISON', 'OverlappingDegreeAv').get('DIFF');
% % % ovdegree_av_BUD_p1 = c_BUD.get('COMPARISON', 'OverlappingDegreeAv').get('P1');
% % % ovdegree_av_BUD_p2 = c_BUD.get('COMPARISON', 'OverlappingDegreeAv').get('P2');
% % % ovdegree_av_BUD_cil = c_BUD.get('COMPARISON', 'OverlappingDegreeAv').get('CIL');
% % % ovdegree_av_BUD_ciu = c_BUD.get('COMPARISON', 'OverlappingDegreeAv').get('CIU');

% % % edgeov_BUD_diff = c_BUD.get('COMPARISON', 'EdgeOverlap').get('DIFF');
% % % edgeov_BUD_p1 = c_BUD.get('COMPARISON', 'EdgeOverlap').get('P1');
% % % edgeov_BUD_p2 = c_BUD.get('COMPARISON', 'EdgeOverlap').get('P2');
% % % edgeov_BUD_cil = c_BUD.get('COMPARISON', 'EdgeOverlap').get('CIL');
% % % edgeov_BUD_ciu = c_BUD.get('COMPARISON', 'EdgeOverlap').get('CIU');
% % % mpc_av_BUD_ciu = c_BUD.get('COMPARISON', 'MultiplexParticipationAv').get('CIU');