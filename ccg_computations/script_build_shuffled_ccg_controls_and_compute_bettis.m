% ----------------------------------------------------------------
% BUILD SHUFFLED CCG CONTROLS AND COMPUTE BETTIS
%
% Beginning from a CCG matrix, construct a sequence of controls
% by shuffling the entries of the matrix to destroy correlation
% between the entries. For each such control matrix, build a
% family of graphs filtered by edge density. Then count the
% cliques in each graph in the family and use Perseus to compute 
% the betti numbers of these clique complexes.
% 
% This script assumes that parameters have been set using the 
% script SETUP COMPUTATIONS or an equivalent process and that
% a "total" CCG has been built as in BUILD FILTERED MATRICES AND 
% COMPUTE BETTIS
% ----------------------------------------------------------------

% ----------------------------------------------------------------
% Build controls by repeatedly shuffling the CCG matrix entries
% then filtering the resulting graphs by graph density.
% ----------------------------------------------------------------

shuffledTotalCCG = cell(Parameters.numControls,1);
filteredShuffledCCGGraphs = cell(Parameters.numControls,1);

for j=1:Parameters.numControls

    % Shuffle CCG matrix entries and filter -- this is equivalent to
    % shuffling each of the filtered data graphs in a compatible way
    
    shuffledTotalCCG{j} = shuffle_symmetric_matrix_entries(totalCCG);
    filteredShuffledCCGGraphs{j} = ...
        weighted_graph_to_p_thresholded_graphs(shuffledTotalCCG{j}, ...
        Parameters.PStep, Parameters.MaxP);

end


% ----------------------------------------------------------------
% Count cliques in each family of graphs and write these to files
% in a format useable by Perseus to compute filtered homology.
% ----------------------------------------------------------------

for j=1:Parameters.numControls
    count_cliques_and_write_to_file(filteredShuffledCCGGraphs{j}, ...
        Parameters.Dimension, 'shuffled_ccg'. ''. j);
end

% ----------------------------------------------------------------
% Use Perseus to compute persistent homology
% ----------------------------------------------------------------

for j=1:Parameters.numControls
    system(sprintf('%s/perseus nmfsimtop shuffled_ccg_simplices_%g.s shuffled_ccg_homology_%g.s',...
        Parameters.PerseusDirectory, j,j));
end
