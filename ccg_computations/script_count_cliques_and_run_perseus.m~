% ----------------------------------------------------------------
% COUNT CLIQUES AND RUN PERSEUS
%
% Given sequences of filtered graphs, use Cliquer to count maximal
% cliques and all cliques in the important dimension range, then 
% output these files in a Perseus-compatable format.
%
% This script expects to receive sequences of data, shuffled CCG
% and WME filtered graphs, such as those produced by the script
% BUILD FILTERED MATRICES AND CONTROLS.
% ----------------------------------------------------------------

% ----------------------------------------------------------------
% Count cliques in each family of graphs and write these to files
% in a format useable by Perseus to compute filtered homology.
% ----------------------------------------------------------------

count_cliques_and_write_to_file(filteredCCGGraphs, ...
    Parameters.Dimension, 'data'. ''. 0);

for j=1:Parameters.numControls
    count_cliques_and_write_to_file(filteredShuffledCCGGraphs{j}, ...
        Parameters.Dimension, 'shuffled_ccg'. ''. j);

    count_cliques_and_write_to_file(filteredWMEGraphs{j}, ...
        Parameters.Dimension, 'wme'. ''. j);
end

% ----------------------------------------------------------------
% Use Perseus to compute persistent homology
% ----------------------------------------------------------------

system(sprintf('%s/perseus nmfsimtop data_simplices.s data_homology.s',...
    Parameters.PerseusDirectory));
for j=1:Parameters.numControls
    system(sprintf('%s/perseus nmfsimtop shuffled_ccg_simplices_%g.s shuffled_ccg_homology_%g.s',...
        Parameters.PerseusDirectory, j,j));
    system(sprintf(...
        '%s/perseus nmfsimtop wme_simplices_%g.s wme_homology_%g.s',...
        Parameters.PerseusDirectory, j, j));
end
