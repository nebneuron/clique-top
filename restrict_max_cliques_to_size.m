function [ restrictedCliques ] = restrict_max_cliques_to_size( ...
    maximalCliques, maxSize, firstVertex, secondVertex )

% ----------------------------------------------------------------
% RESTRICT CLIQUES TO SIZE
% written by Chad Giusti, 6/2014
%
% Given a cell array whose elements are positive integer arrays
% listing vertices in the maximal cliques in a graph, return a
% cell array of cliques appearing in the graph of size no larger 
% than maxSize. The list may contain repetitions.
%
% INPUTS:
%	maximalCliques: cell array of positive integer arrays listing
%       vertices in maximal cliques of a graph
%   maxSize: maximum clique size of interest
%
% OUTPUTS:
%   restrictedCliques: maximal cliques in the graph of size no 
%       more than maxSize
%
% ----------------------------------------------------------------

numSmallCliques = 0;
for j=1:length(maximalCliques)
    if (length(maximalCliques{j}) < maxSize)
        numSmallCliques = numSmallCliques + 1;
    else
        numSmallCliques = numSmallCliques + ...
            nchoosek(length(maximalCliques{j})-2, maxSize-2);
    end
end

restrictedCliques = cell(numSmallCliques,1);
thisSmallClique = 1;

for j=1:length(maximalCliques)
    if length(maximalCliques{j}) < maxSize
        restrictedCliques{thisSmallClique} = maximalCliques{j};
        thisSmallClique = thisSmallClique + 1; 
    else
        vertices = maximalCliques{j};
        subVertices = vertices((vertices ~= firstVertex) & ...
            (vertices ~= secondVertex)); % all new cliques will contain
                                         % the edge removed at this
                                         % filtration level
        theseSmallCliques = nchoosek(subVertices, maxSize-2);
        for k=1:size(theseSmallCliques,1)
            restrictedCliques{thisSmallClique} = ...
                [theseSmallCliques(k,:) firstVertex secondVertex];
            thisSmallClique = thisSmallClique + 1; 
        end
    end
end

end

