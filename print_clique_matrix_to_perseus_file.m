function [ ] = print_clique_matrix_to_perseus_file( cliqueMatrix, ...,
    maxSize, vertices, fid, filtration )

% ----------------------------------------------------------------
% PRINT CLIQUE MATRIX TO PERSEUS FILE
% written by Chad Giusti, 9/2014
%
% Output a sparse matrix whose rows are cliques in a particular 
% filtration level and columns are vertices to the file given by fid in the 
% Perseus non-manifold simplicial complex format: each line corresponds 
% to a single clique, and is given by the size of the clique - 1, then the 
% vertices, then the filtration level
%
% INPUT: 
%   cliqueMatrix: binary sparse matrix whose (c,i) entry is 1 if and only 
%       if vertex i appears in clique c
%   fid: file into which to print the cliques
%   filtration: filtration number with which to tag these cliques
%   vertices: vertices which appear in every clique, those in the edge 
%       added at this filtration, if empty, just print the cliques
%       in the list.
%   maxSize: maximum size clique to write to the file -- enumerate
%       subcliques of this size if a maximal clique is larger. 
%       If less than 2, write maximal cliques of any size. (Otherwise
%       only vertices ever appear -- this is nonsense.)
%
% ----------------------------------------------------------------

if (isempty(vertices)) || (maxSize < 2)
    for c=1:size(cliqueMatrix, 1)
        thisClique = find(cliqueMatrix(c,:));
        fprintf(fid, sprintf('%i ', length(thisClique)-1));
        for i=1:length(thisClique)
            fprintf(fid, '%i ', thisClique(i));
        end
        fprintf(fid, sprintf('%i\n',filtration));
    end
else
    for c=1:size(cliqueMatrix, 1)
            thisClique = setdiff(find(cliqueMatrix(c,:)), vertices);
            if (length(thisClique) > maxSize - 2)
                subCliques = nchoosek(thisClique, maxSize - 2);
                for s = 1:size(subCliques,1)              
                    fprintf(fid, sprintf('%i ', maxSize - 1));
                    for i=1:maxSize-2
                        fprintf(fid, '%i ', subCliques(s,i));
                    end
                    fprintf(fid, '%i %i ', vertices(1), vertices(2));
                    fprintf(fid, sprintf('%i\n',filtration));
                end
            else
                fprintf(fid, sprintf('%i ', length(thisClique)+1));
                for i=1:length(thisClique)
                    fprintf(fid, '%i ', thisClique(i));
                end
                fprintf(fid, '%i %i ', vertices(1), vertices(2));
                fprintf(fid, sprintf('%i\n',filtration));
            end
    end
end    
    
end

