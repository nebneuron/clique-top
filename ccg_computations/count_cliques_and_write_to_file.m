function count_cliques_and_write_to_file(filteredGraphs, ...
    maxCliqueDim, filePrefix, fileSuffix, runCounter)

% ----------------------------------------------------------------
% COUNT CLIQUES AND WRITE TO FILE
%
% Count the maximal cliques in a (filtered) family of graphs and 
% write the output to a pair of files. One records the maximal
% cliques and the other is Perseus-ready, recording only cliques
% in the prescribed dimension range for homology computation.
%
% INPUT:
%   filteredGraphs: Cell array containing adjacency matrices of 
%       graphs, intended to be a filtered family of graphs
%   maxCliqueDim: Maximum dimension of clique to record in the
%       Perseus file. (Dim = number of vertices - 1)
%   filePrefix: Prefix of clique file name
%   fileSuffix: Suffix of clique file name
%   runCounter: Number to append to clique file name -- intended
%       for control runs with the same base file data. Set to zero
%       to omit adding a counter.
%
% ----------------------------------------------------------------

numFiltrations = length(filteredGraphs);


% ----------------------------------------------------------------
% Open output files and insert first line indicating that
% vertices are indexed by natural numbers
% ----------------------------------------------------------------

if (runCounter > 0)
    cliqueFid = fopen(sprintf('%s_simplices%s_%i.s',...
        filePrefix, fileSuffix, runCounter), 'w');
    cliqueMaxFid = fopen(sprintf('%s_max_simplices%s_%i.s',...
        filePrefix, fileSuffix, runCounter), 'w');
else
    cliqueFid = fopen(sprintf('%s_simplices%s.s',filePrefix,...
        fileSuffix), 'w');
    cliqueMaxFid = fopen(sprintf('%s_max_simplices%s.s',...
        filePrefix, fileSuffix), 'w');
end    

fprintf(cliqueFid, '1\n');    
fprintf(cliqueMaxFid, '1\n');    

% ----------------------------------------------------------------
% Count cliques and write to files
% ----------------------------------------------------------------

for i=1:numFiltrations
    [allCliques, maximalCliques] = ...
        find_cliques_and_maximal_cliques(...
        Graph(logical(filteredGraphs{i})), maxCliqueDim+1);
        print_cliques_to_perseus_file(maximalCliques, cliqueMaxFid, i);
        print_cliques_to_perseus_file(allCliques, cliqueFid, i);
end

% ----------------------------------------------------------------
% Close files
% ----------------------------------------------------------------


fclose(cliqueFid);
fclose(cliqueMaxFid);

end

