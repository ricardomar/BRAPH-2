%EXAMPLE_CON_CV_WU
% Script example pipeline CON CV WU

clear variables %#ok<*NASGU>

%% Load BrainAtlas
im_ba = ImporterBrainAtlasXLS( ...
    'FILE', [fileparts(which('example_CON_WU')) filesep 'example data CON (DTI)' filesep 'desikan_atlas.xlsx'], ...
    'WAITBAR', true ...
    );

ba = im_ba.get('BA');

%% Load Groups of SubjectCON
im_gr1 = ImporterGroupSubjectCON_XLS( ...
    'DIRECTORY', [fileparts(which('example_CON_WU')) filesep 'example data CON (DTI)' filesep 'xls' filesep 'GroupName1'], ...
    'BA', ba, ...
    'WAITBAR', true ...
    );

gr1 = im_gr1.get('GR');

im_gr2 = ImporterGroupSubjectCON_XLS( ...
    'DIRECTORY', [fileparts(which('example_CON_WU')) filesep 'example data CON (DTI)' filesep 'xls' filesep 'GroupName2'], ...
    'BA', ba, ...
    'WAITBAR', true ...
    );

gr2 = im_gr2.get('GR');

%% Initiate the Cross Validation Analysis
nncv = NNClassifierCrossValidation_CON_WU( ...
    'GR1', gr1, ...
    'GR2', gr2, ...
    'KFOLD', 5, ...
    'REPETITION', 1, ...
    'FEATURE_MASK', 0.05, ...
    'PLOT_CM', true, ...
    'PLOT_ROC', true, ...
    'PLOT_MAP', true ...
    );

%% Evaluate the Performance
nncv.memorize('NNE_DICT');
auc = nncv.memorize('AUC');
auc_cil = nncv.get('AUC_CIL');
auc_ciu = nncv.get('AUC_CIU');
cm = nncv.get('CONFUSION_MATRIX');
map = nncv.get('CONTRIBUTION_MAP');

close all