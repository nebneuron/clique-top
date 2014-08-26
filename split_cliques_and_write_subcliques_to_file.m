function split_cliques_and_write_subcliques_to_file( maxCliques, ...
    adjacencyMatrix, edgeList, maxDim, filePrefix, writeMaxCliques )

% ----------------------------------------------------------------
% SPLIT CLIQUES AND WRITE SUBCLIQUES TO FILE
% written by Chad Giusti, 6/2014
%
% Given a list of maximal cliques in the clique complex of a 
% thresholding of a matrix, use an iterative "splitting" method
% to compute cliques at successively lower threshold values.
% , writing subcliques of the appropriate dimension (at most 
% two larger than the maximum betti) to a file for input to 
% Perseus.
% 
% INPUTS:
%	maxCliques: a Collection object containing all of the
%       maximal cliques of the thresholding of adjacencyMatrix
%	adjacencyMatrix: the symmetric matrix whose order complex
%       we are working with
%   edgeList: a list of edges in the graph, ordered by weight,
%       used to determine which edge to remove next
%   maxDim: maximum homological dimension for computations
%   filePrefix: file prefix for output file
%   writeMaxCliques: boolean flag for writing a file containing
%       the maximal cliques -- may slow process substantially
%
% ----------------------------------------------------------------

cliqueFid = fopen(sprintf('%s_simplices.txt',filePrefix), 'w');
fprintf(cliqueFid, '1\n');    

if writeMaxCliques
    cliqueMaxFid = fopen(sprintf('%s_max_simplices.txt', filePrefix), 'w');
    fprintf(cliqueMaxFid, '1\n');    
end

% ----------------------------------------------------------------
% Count cliques and write to files
% ----------------------------------------------------------------

maxCliqueMatrix = maxCliques.ToMatrix();

for i=length(edgeList):-1:1

        [firstVertex, secondVertex] = find(adjacencyMatrix == ...
            edgeList(i), 1);
        [maxCliqueMatrix, brokenCliqueMatrix] =...
            find_and_split_cliques_containing_edge( maxCliqueMatrix,...
            [firstVertex, secondVertex] );
    
        brokenCliqueSets = cell(size(brokenCliqueMatrix,1),1);
        for k=1:size(brokenCliqueMatrix,1)
            brokenCliqueSets{k} = find(brokenCliqueMatrix(k,:)>0);
        end

        if writeMaxCliques
            print_cliques_to_perseus_file(brokenCliqueSets, ...
                cliqueMaxFid, i);
        end

        allBrokenCliques =...
            restrict_max_cliques_to_dimension(brokenCliqueSets, ...
                maxDim+1, firstVertex, secondVertex);
        print_cliques_to_perseus_file(allBrokenCliques, cliqueFid, i);

end

% ----------------------------------------------------------------
% Ensure all vertices appear on their own in the complex
% ----------------------------------------------------------------

vertexSet = cell(size(adjacencyMatrix,1));
for i=1:size(adjacencyMatrix,1)
    vertexSet{i} = i * ones(1);
end

print_cliques_to_perseus_file(vertexSet, cliqueFid, 1);
fclose(cliqueFid);

if writeMaxCliques
    print_cliques_to_perseus_file(vertexSet, cliqueMaxFid, 1);
    fclose(cliqueMaxFid);
end

end

