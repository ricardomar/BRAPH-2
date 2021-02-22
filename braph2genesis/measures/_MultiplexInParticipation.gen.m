%% ¡header!
MultiplexInParticipation < Measure (m, multiplex in-participation) is the graph multiplex in-participation.

%%% ¡description!
The multiplex in-participation is the heterogenerity of the number of inward 
neighbours of a node across the layers.
    
%%% ¡shape!
shape = Measure.NODAL;

%%% ¡scope!
scope = Measure.SUPERGLOBAL;

%%% ¡parametricity!
parametricity = Measure.NONPARAMETRIC;

%%% ¡compatible_graphs!
MultiplexGraphBD
MultiplexGraphWD

%% ¡props_update!

%%% ¡prop!
M (result, cell) is the multiplex in-participation.
%%%% ¡calculate!
g = m.get('G');  % graph from measure class
B = g.get('A');  % cell with adjacency matrix (for graph) or 2D-cell array (for multigraph, multiplex, etc.)
L = g.layernumber();
N = g.nodenumber();

in_degree = InDegree('G', g).get('M');
overlapping_in_degree = OverlappingInDegree('G', g).get('M');

if L > 0   
    multiplex_in_participation =  zeros(N(1), 1);
else
    multiplex_in_participation =  zeros(1);
end

for li = 1:1:L
    multiplex_in_participation = multiplex_in_participation + (in_degree{li}./overlapping_in_degree{1}).^2;
end
multiplex_in_participation = L / (L - 1) * (1 - multiplex_in_participation);
multiplex_in_participation(isnan(multiplex_in_participation)) = 0;  % Should return zeros, since NaN happens when strength = 0 and overlapping strength = 0 for all regions
value = {multiplex_in_participation};

%% ¡tests!

%%% ¡test!
%%%% ¡name!
MultiplexGraphBD
%%%% ¡code!
B11 = [
    0   1   1
    1   0   0
    1   0   0
    ];
B22 = [
    0   1   0
    1   0   1
    0   1   0
    ];
B = {B11  B22};

known_multiplex_participation = {[8/9 8/9 1]'};

g = MultiplexGraphBD('B', B);
multiplex_in_participation = MultiplexParticipation('G', g);

assert(isequal(multiplex_in_participation.get('M'), known_multiplex_participation), ...
    [BRAPH2.STR ':MultiplexParticipation:' BRAPH2.BUG_ERR], ...
    'MultiplexParticipation is not being calculated correctly for MultiplexGraphBD.')

%%% ¡test!
%%%% ¡name!
MultiplexGraphWD
%%%% ¡code!
B11 = [
    0   .2  1
    .2  0   0
    1   0   0
    ];
B22 = [
    0   1   0
    1   0   .3
    0   .3  0
    ];
B = {B11  B22};

known_multiplex_participation = {[8/9 8/9 1]'};

g = MultiplexGraphWD('B', B);
multiplex_in_participation = MultiplexParticipation('G', g);

assert(isequal(multiplex_in_participation.get('M'), known_multiplex_participation), ...
    [BRAPH2.STR ':MultiplexParticipation:' BRAPH2.BUG_ERR], ...
    'MultiplexParticipation is not being calculated correctly for MultiplexGraphWD.')