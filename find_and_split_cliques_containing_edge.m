function [ newCliques, brokenCliques ] =...
    find_and_split_cliques_containing_edge( cliqueMatrix, edge )

% ----------------------------------------------------------------
% FIND AND SPLIT CLIQUES CONTAINING EDGE
% written by Chad Giusti, 11/2014
%
% Given an array whose columns are binary vectors encoding cliques
% in a graph, remove the given edge from the graph and return a 
% list of cliques in the resulting subgraph.
%
% INPUTS:
%	cliqueMatrix: a sparse binary matrix whose rows correspond
%       to cliques in a graph and columns to vertices, with an entry 
%       of 1 precisely when a vertex is in a clique
%   edge: a two element vector of integers whose elements are the 
%       vertices of the edge to remove
%
% OUTPUTS:
%   newCliqueMatrix: same format as input, with the cliques modified
%       to reflect removal of the input edge from the graph
%   brokenCliquesMatrix: a list of the cliques that were split by
%       this process
%
% ----------------------------------------------------------------

matrixSize = size(cliqueMatrix,1);

% ----------------------------------------------------------------
% Get a list of cliques containing the specified edge (those to
% be broken at this filtration) and those not containing the
% edge (which will simply be copied).
% ----------------------------------------------------------------

edgeInClique = cliqueMatrix(:, edge(1)) & cliqueMatrix(:, edge(2));

brokenCliques = cliqueMatrix(edgeInClique, :);
numBrokenCliques = size(brokenCliques,1);

cliquesNotContainingEdge = cliqueMatrix(~edgeInClique, :);

% ----------------------------------------------------------------
% Build sparse matrix containing cliques after splitting
% ----------------------------------------------------------------

newCliques = [brokenCliques; brokenCliques];
newCliques(1:numBrokenCliques, edge(1)) = 0;
newCliques(numBrokenCliques+1:2*numBrokenCliques, edge(2)) = 0;

cliqueIntersectionSizes = cliquesNotContainingEdge * newCliques';
newCliqueSizes = sum(newCliques,2);
keepCliques = true(2*numBrokenCliques,1);
for i=1:2*numBrokenCliques
    keepCliques(i) = ~any(cliqueIntersectionSizes(:,i) == newCliqueSizes(i));
end

newCliques = [newCliques(keepCliques,:); cliquesNotContainingEdge];

end

