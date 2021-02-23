%% ¡header!
MultiplexGraphBUT < MultiplexGraphWU (g, multiplex binary undirected multigraph with fixed thresholds) is a multiplex binary undirected multigraph with fixed thresholds.

%%% ¡description!
In a multiplex binary undirected multigraph with fixed thresholds (BUT), 
all the layers consist of binary undirected (BU) multiplex graphs 
derived from the same weighted supra-connectivity matrices 
binarized at different thresholds.

%%% ¡ensemble!
false

%%% ¡graph!
graph = Graph.MULTIGRAPH;

%%% ¡connectivity!
connectivity = Graph.BINARY * ones(layernumber);

%%% ¡directionality!
directionality = Graph.UNDIRECTED * ones(layernumber);

%%% ¡selfconnectivity!
selfconnectivity = Graph.SELFCONNECTED * ones(layernumber);
selfconnectivity(1:layernumber+1:end) = Graph.NONSELFCONNECTED;                

%%% ¡negativity!
negativity = Graph.NONNEGATIVE * ones(layernumber);

%% ¡props!

%%% ¡prop!
THRESHOLDS (data, rvector) is the vector of thresholds.

%% ¡props_update!

%%% ¡prop!
A (result, cell) is the cell array containing the multiplex binary adjacency matrices of the multiplex binary undirected multigraph. 
%%%% ¡calculate!
A_WU = calculateValue@MultiplexGraphWU(g, prop);

thresholds = g.get('THRESHOLDS');
L = length(A_WU); % number of layers
A = cell(length(thresholds)*L);

for i = 1:1:length(thresholds)
    density = thresholds(i);
    layer = 1;
    for j = (i*2) - 1:1: (i*2) + L - 2     
        A{j, j} = binarize(A_WU{layer, layer}, 'threshold', threshold);
        layer = layer + 1;
    end
end

value = A;

%% ¡tests!

%%% ¡test!
%%%% ¡name!
Constructor
%%%% ¡code!
A = [
    0 .1 .2 .3 .4
    .1 0 .1 .2 .3
    .2 .1 0 .1 .2
    .3 .2 .1 0 .1
    .4 .3 .2 .1 0
    ];
B = {A, A};
g = MultiplexGraphBUT('B', B, 'THRESHOLDS', [0 .1 .2 .3 .4 .5]);

A = g.get('A');