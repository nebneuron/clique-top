function [graphs] = ...
    weighted_graph_to_p_thresholded_graphs(weightedGraph, ...
        pFiltrationStep, maxP) 

% ----------------------------------------------------------------
% WEIGHTED GRAPH TO P THRESHOLDED GRAPHS
%
% Given the adjacency matrix of a weighted simple graph, return a
% filtered sequence of graphs corresponding to the range of 
% Erdos-Renyi p values [0, maxP].
%
% INPUTS: 
%   weightedGraph: A square symmetric matrix which is zero along
%       the diagonal.
%   pFilatrationStep: Size of step in Erdos-Renyi p per filtration 
%       level
%   maxP: Maximum Erdos-Renyi p value for which to return a graph
%
% OUTPUTS: 
%   graphs: Cell array of adjecency matrices for the graph 
%       at each filtration level. Matrices in the kth filtration
%       have Erdos-Renyi p at least k * pFiltrationStep + minP
%       though this is only a lower bound since edge weights 
%       may coincide, forcing us to include several edges in a 
%       single increment.
% ----------------------------------------------------------------

n = size(weightedGraph, 1);
twicePossibleEdges = n * (n - 1);

% ----------------------------------------------------------------
% Sort the edge weights so we can include them in increasing order
% ----------------------------------------------------------------

edgeWeights = fliplr(unique(weightedGraph, 'sorted')')';
thisWeightIndex = 0;

% ----------------------------------------------------------------
% For each filtration step, add edges in order of increasing 
% weight until we are at or above the corresponding ER p value
% ----------------------------------------------------------------

graphs = cell(round(maxP/pFiltrationStep),1);
pThresholds = 0:pFiltrationStep:maxP;

graphs{1} = zeros(n);
thisERp = 0;
for i=2:length(pThresholds)  % for each p threshold
    while (thisERp < pThresholds(i)) 
        thisWeightIndex = thisWeightIndex + 1;
        curGraph = (weightedGraph >= edgeWeights(thisWeightIndex)) -...
            eye(n);
        curGraph = (curGraph + curGraph') > 0;
                            % some edges may appear non-symmetrically due
                            % to rounding errors in floating point division

        thisERp = nnz(curGraph)/twicePossibleEdges;
    end                     % include edges until graph has ER p
                            % larger than threshold
    graphs{i} = curGraph;    % and record that graph at filtration i
end
           
end                     







