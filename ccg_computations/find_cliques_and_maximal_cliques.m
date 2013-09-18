function [ allCliques, maximalCliques ] = ...
    find_cliques_and_maximal_cliques( thisGraph, maxDim )

% ----------------------------------------------------------------
% FIND CLIQUES AND MAXIMAL CLIQUES
%
% Given an adjacency matrix for a graph, find both a list of all 
% cliques in the graph up to a fixed dimension (= number of 
% vertices in the clique - 1) and a list of all maximal cliques.
%
% INPUT:
%   thisGraph: A binary adjacency matrix for a simple graph.
%   maxDim: The maximal dimension of cliques to enumerate. This
%       smaller list is used for Perseus computations of homology
%       through the range (maxDim - 1).
%
% OUTPUT:
%   allCliques: all cliques appearing in the restricted dimension
%       range, as a cell array of vectors
%   maximalCliques: all maximal cliques appearing in the graph
%       as a cell array of vectors
% ----------------------------------------------------------------

maximalCliques = thisGraph.GetCliques(1,0, true);
maximalCliques = maximalCliques.ToSubsets();

numSmallCliques = 0;
for j=1:length(maximalCliques)
    numSmallCliques = numSmallCliques + nchoosek(max(maxDim+1,length(maximalCliques{j})), maxDim+1);
end

allCliques = cell(numSmallCliques,1);
thisSmallClique = 1;

for j=1:length(maximalCliques)
    if length(maximalCliques{j}) <= maxDim
        allCliques{thisSmallClique} = maximalCliques{j};
        thisSmallClique = thisSmallClique + 1; 
    else
        theseSmallCliques = nchoosek(maximalCliques{j}, maxDim+1);
        for k=1:size(theseSmallCliques,1)
            allCliques{thisSmallClique} = theseSmallCliques(k,:);
            thisSmallClique = thisSmallClique + 1; 
        end
    end
end

end

