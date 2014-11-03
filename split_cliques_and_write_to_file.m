function [ maxFiltration ] = split_cliques_and_write_to_file( ...
    symMatrix, maxCliqueSize, maxDensity, filePrefix, writeMaxCliques )

% ----------------------------------------------------------------
% SPLIT CLIQUES AND WRITE TO FILE
% written by Chad Giusti, 11/2014
%
% Given a list of maximal cliques in the clique complex of a 
% thresholding of a matrix, use an iterative "splitting" method
% to compute cliques at successively lower threshold values.
% , writing subcliques of the appropriate dimension (at most 
% two larger than the maximum betti) to a file for input to 
% Perseus.
% 
% INPUTS:
%	symMatrix: the symmetric matrix whose order complex
%       we are working with 
%   maxCliqueSize: maximum size of clique to enumerate
%   maxDensity: maximum edge density -- stopping condition
%   filePrefix: file prefix for output file
%   writeMaxCliques: boolean flag for writing a file containing
%       the maximal cliques -- may slow process substantially
%
% ----------------------------------------------------------------

matrixSize = size(symMatrix, 1);

[ thresholdedMatrix, edgeList ] = threshold_graph_by_density(...
    symMatrix, maxDensity );

maxFiltration = length(edgeList);

if (maxDensity < 1)
    maximalGraph = Graph(logical(thresholdedMatrix));

    initialMaxCliques = maximalGraph.GetCliques(1,0, true);
else
    initialMaxCliques = Collection(ones(1,matrixSize));
end

% ----------------------------------------------------------------
% Count cliques in the family of graphs obtained by thresholding
% the input matrix at every density in [0, maxDensity], and write
% these to files in a format useable by Perseus to compute 
% persistent homology.
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

maxCliqueMatrix = initialMaxCliques.ToMatrix();

for i=length(edgeList):-1:1

        [firstVertex, secondVertex] = find(symMatrix == ...
            edgeList(i), 1);
        [maxCliqueMatrix, brokenCliqueMatrix] =...
            find_and_split_cliques_containing_edge( maxCliqueMatrix,...
            [firstVertex, secondVertex] );
    
        brokenCliqueSets = cell(size(brokenCliqueMatrix,1),1);
        for k=1:size(brokenCliqueMatrix,1)
            brokenCliqueSets{k} = find(brokenCliqueMatrix(k,:)>0);
        end

        if writeMaxCliques
            print_clique_list_to_perseus_file(brokenCliqueSets, ...
                cliqueMaxFid, i);
        end

        allBrokenCliques =...
            restrict_max_cliques_to_size(brokenCliqueSets, ...
                maxCliqueSize, firstVertex, secondVertex);
        print_clique_list_to_perseus_file(allBrokenCliques, cliqueFid, i);

end

% ----------------------------------------------------------------
% Ensure all vertices appear on their own in the complex
% ----------------------------------------------------------------

vertexSet = cell(matrixSize,1);
for i=1:matrixSize
    vertexSet{i} = i * ones(1);
end

print_clique_list_to_perseus_file(vertexSet, cliqueFid, 1);
fclose(cliqueFid);

if writeMaxCliques
    print_clique_list_to_perseus_file(vertexSet, cliqueMaxFid, 1);
    fclose(cliqueMaxFid);
end

end

