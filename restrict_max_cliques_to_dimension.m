function [ restrictedCliques ] = restrict_max_cliques_to_dimension( ...
    maximalCliques, maxDim, firstVertex, secondVertex )

% ----------------------------------------------------------------
% RESTRICT CLIQUES TO DIMENSION
% written by Chad Giusti, 6/2014
%
% Given a cell array whose elements are positive integer arrays
% listing vertices in the maximal cliques in a graph, return a
% cell array of cliques appearing in the graph of size no larger 
% than maxDim + 1. The list may contain repetitions.
%
% INPUTS:
%	maximalCliques: cell array of positive integer arrays listing
%       vertices in maximal cliques of a graph
%   maxDim: maximum homological dimension of interest
%
% OUTPUTS:
%   restrictedCliques: maximal cliques in the graph of size no 
%       more than maxDim + 1
%
% ----------------------------------------------------------------

numSmallCliques = 0;
for j=1:length(maximalCliques)
    if (length(maximalCliques{j}) <= maxDim)
        numSmallCliques = numSmallCliques + 1;
    else
        numSmallCliques = numSmallCliques + ...
            nchoosek(length(maximalCliques{j})-2, maxDim-1);
    end
end

restrictedCliques = cell(numSmallCliques,1);
thisSmallClique = 1;

for j=1:length(maximalCliques)
    if length(maximalCliques{j}) <= maxDim
        restrictedCliques{thisSmallClique} = maximalCliques{j};
        thisSmallClique = thisSmallClique + 1; 
    else
        vertices = maximalCliques{j};
        subVertices = vertices((vertices ~= firstVertex) & ...
            (vertices ~= secondVertex)); % all new cliques will contain
                                         % the edge removed at this
                                         % filtration level
        theseSmallCliques = nchoosek(subVertices, maxDim-1);
        for k=1:size(theseSmallCliques,1)
            restrictedCliques{thisSmallClique} = ...
                [theseSmallCliques(k,:) firstVertex secondVertex];
            thisSmallClique = thisSmallClique + 1; 
        end
    end
end

end

