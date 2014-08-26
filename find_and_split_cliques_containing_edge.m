function [ newCliqueMatrix, brokenCliquesMatrix ] =...
    find_and_split_cliques_containing_edge( cliqueMatrix, edge )

% ----------------------------------------------------------------
% FIND AND SPLIT CLIQUES CONTAINING EDGE
% written by Chad Giusti, 6/2014
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

numVertices = size(cliqueMatrix,2);
numCliques = size(cliqueMatrix,1);

% ----------------------------------------------------------------
% Reserve memory for largest possible sparse output matrices --
% worst case, the cliques could all split in two.
% ----------------------------------------------------------------

newCliqueMatrixEntries = zeros(2*numCliques*numVertices, 3);
brokenCliques = zeros(2*numCliques*numVertices,3);

curRow = 1;
curEntry = 1;
curBrokenRow = 1;
curBrokenEntry = 1;

% ----------------------------------------------------------------
% Using sparse matrix/vector multiplication, get list of how many
% (0, 1 or 2) of the specified vertices are in each clique
% ----------------------------------------------------------------

vertexVec = sparse([edge(1), edge(2)], [1,2], [1,1], numVertices, 2);
vertexInClique = cliqueMatrix * vertexVec;
edgeInClique = sum(vertexInClique,2);

% ----------------------------------------------------------------
% Walk through the cliques, splitting those that contain the edge
% into pairs of subcliques
% ----------------------------------------------------------------

for i = 1:numCliques
    if sum(edgeInClique(i,:)) == 2    % if both vertices are in the clique
                                      % it splits in half
        
        % --------------------------------------------------------
        % Get a list of the vertices and record that we're 
        % splitting this clique
        % --------------------------------------------------------

        cliqueVertices = find(cliqueMatrix(i,:) > 0)';
        numVertices = length(cliqueVertices);
        brokenCliques(curBrokenEntry:curBrokenEntry+numVertices-1,:)...
            = [ones(numVertices,1)*curBrokenRow,...
               cliqueVertices, ones(numVertices,1)];
        curBrokenEntry = curBrokenEntry + numVertices;
        curBrokenRow = curBrokenRow + 1;

        % --------------------------------------------------------
        % Build a copy of the clique with both vertices missing
        % and see if this subclique is contained in any other 
        % cliques
        % --------------------------------------------------------

        subcliqueVertices = cliqueMatrix(i,:);
        subcliqueVertices(edge) = 0;      
        subcliqueSize = numVertices - 2;
        cliqueOverlapSize = cliqueMatrix * subcliqueVertices';  
        matches = find(cliqueOverlapSize == subcliqueSize); 
        
        switch length(matches)          
            case 1                    % the list contains only 
                                      % the clique we started with
                                      % so keep both sub-cliques
                cliqueVertices = [find(subcliqueVertices > 0)'; edge(1)];                
                numVertices = length(cliqueVertices);
                newCliqueMatrixEntries(curEntry:curEntry+numVertices-1,:)...
                    = [ones(numVertices,1)*curRow, cliqueVertices,...
                    ones(numVertices,1)];
                curEntry= curEntry + numVertices;
                curRow = curRow +1;                
                
                cliqueVertices = [cliqueVertices(1:end-1); edge(2)];
                newCliqueMatrixEntries(curEntry:curEntry+numVertices-1,:)...
                    = [ones(numVertices,1)*curRow, cliqueVertices, ones(numVertices,1)];
                curEntry= curEntry + numVertices;
                curRow = curRow + 1;

            otherwise                 % the subcliques we're creating
                                      % may already exist, so check
                                      % and don't duplicate if they do
                otherCliquesContainingVertex = ...
                    (sum(vertexInClique(matches,:),1)) - [1,1];
                
                if nnz(otherCliquesContainingVertex)<2
                    baseVecCols = find(subcliqueVertices >0)';
                    numVertices = length(baseVecCols)+1;
                    if (otherCliquesContainingVertex(1) == 0)
                        cliqueVertices = [baseVecCols; edge(1)];                
                        newCliqueMatrixEntries(curEntry:curEntry+numVertices-1,:)...
                            = [ones(numVertices,1)*curRow, ...
                               cliqueVertices, ones(numVertices,1)];
                        curEntry= curEntry + numVertices;
                        curRow = curRow + 1;
                        
                    end
                    if (otherCliquesContainingVertex(2) == 0)
                        cliqueVertices = [baseVecCols; edge(2)];                
                        newCliqueMatrixEntries(curEntry:curEntry+numVertices-1,:)...
                            = [ones(numVertices,1)*curRow, ...
                               cliqueVertices, ones(numVertices,1)];
                        curEntry= curEntry + numVertices;
                        curRow = curRow + 1;

                    end
                end
                    
        end
    else                              % the clique does not contain
                                      % the edge, so copy it and move on
        cliqueVertices = find(cliqueMatrix(i,:) > 0)';                
        numVertices = length(cliqueVertices);
        newCliqueMatrixEntries(curEntry:curEntry+numVertices-1,:)...
            = [ones(numVertices,1)*curRow, cliqueVertices, ones(numVertices,1)];
        curEntry= curEntry + numVertices;
        curRow = curRow + 1;
             
    end
end

% ----------------------------------------------------------------
% Build sparse matrices for the output
% ----------------------------------------------------------------

newCliqueMatrixEntries = newCliqueMatrixEntries(1:curEntry-1,:);
newCliqueMatrix = sparse(newCliqueMatrixEntries(:,1),...
    newCliqueMatrixEntries(:,2), newCliqueMatrixEntries(:,3));

brokenCliques = brokenCliques(1:curBrokenEntry-1,:);
brokenCliquesMatrix = sparse(brokenCliques(:,1),...
    brokenCliques(:,2), brokenCliques(:,3));


end

