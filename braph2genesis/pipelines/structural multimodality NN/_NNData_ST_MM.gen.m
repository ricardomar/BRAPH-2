%% ¡header!
NNData_ST_MM < NNData (nnd, data for neural network) produces a dataset to train or test a neural netowrk model for multimodality structural data. 

%% ¡description!
This NN data generates a group of NN subjects, each of which contains the 
input as structural data of multimodality. The generated NN group can be 
used to train or test a neural network model.

%% ¡props_update!

%%% ¡prop!
GR (data, item) is a group of subjects defined as SubjectST class.
%%%% ¡default!
Group('SUB_CLASS', 'SubjectST')

%%% ¡prop!
INPUT_TYPE (data, option) is the input type for training or testing the NN.
%%%% ¡settings
{'structural_data'}
%%%% ¡default!
'structural_data'

%%% ¡prop!
GR_NN (result, item) is a group of NN subjects.
%%%% ¡settings!
'NNGroup'
%%%% ¡default!
NNGroup('SUB_CLASS', 'NNSubject', 'SUB_DICT', IndexedDictionary('IT_CLASS', 'NNSubject'))
%%%% ¡calculate!
if nnd.get('WAITBAR')
    wb = waitbar(0, 'Constructing NN input ...', 'Name', BRAPH2.NAME);
    set_braph2icon(wb)
end

gr = nnd.get('GR');
nn_gr = NNGroup( ...
    'SUB_CLASS', 'NNSubject', ...
    'SUB_DICT', IndexedDictionary('IT_CLASS', 'NNSubject') ...
    );

nn_gr.lock('SUB_CLASS');

nn_gr.set( ...
    'ID', gr.get('ID'), ...
    'LABEL', gr.get('LABEL'), ...
    'NOTES', gr.get('NOTES') ...
    );

atlas = BrainAtlas();
if ~isempty(gr) && ~isa(gr, 'NoValue') && gr.get('SUB_DICT').length > 0 
    atlas = gr.get('SUB_DICT').getItem(1).get('BA');
end

nn_sub_dict = nn_gr.get('SUB_DICT');

for i = 1:1:gr.get('SUB_DICT').length()
	sub = gr.get('SUB_DICT').getItem(i);
    input = sub.get('ST_MP');
    nn_sub = NNSubject( ...
        'ID', [sub.get('ID') ' in ' gr.get('ID')], ...
        'BA', atlas, ...
        'age', sub.get('age'), ...
        'sex', sub.get('sex'), ...
        'INPUT', input, ...
        'TARGET_NAME', nnd.get('TARGET_NAME')...
        );

    nn_sub_dict.add(nn_sub);

    if nnd.get('WAITBAR')
        waitbar(.30 + .70 * i / gr.get('SUB_DICT').length(), wb, ['Constructing subject ' num2str(i) ' of ' num2str(gr.get('SUB_DICT').length())  ' in ' gr.get('ID') ' ...'])
    end
end
nn_gr.set('sub_dict', nn_sub_dict);

if nnd.get('WAITBAR')
    close(wb)
end

value = nn_gr;

%% ¡tests!
%%% ¡test!
%%%% ¡name!
Example 1
%%%% ¡code!
example_NNCV_ST_Classification