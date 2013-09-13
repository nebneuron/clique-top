% ----------------------------------------------------------------
% BUILD FILTERED MATRICES AND COMPUTE BETTIS
%
% Beginning from a CCG matrix, construct a family of graphs
% filtered by graph density. Count cliques in this family of
% graphs and run Perseus to compute the persistent homology
% of the resulting clique complexes.
% 
% This script assumes that a maximal CCG matrix and all 
% associated data has been loaded using the script 
% SETUP COMPUTATIONS or an equivalent process.
% ----------------------------------------------------------------

% ----------------------------------------------------------------
% "Pare down" the maximal CCG matrix to produce a graph whose 
% entries are normalized, assymetric cross correlations between
% point processes. Then threshold the weights in the CCG matrix to 
% produce a filtered sequence of graph adjacency matrices whose 
% filtration levels are given by the Erdos-Renyi p of the graph.
% ----------------------------------------------------------------

totalCCG = maximal_ccg_to_total_asymmetric_normalized_ccg(ccgMatrix, ...
    Parameters.CCGWindowWidth, Parameters.effectiveExperimentLength, ...
    firingRates, Parameters.samplingFrequency);

filteredCCGGraphs = weighted_graph_to_p_thresholded_graphs(totalCCG,...
    Parameters.PStep, Parameters.MaxP);

% ----------------------------------------------------------------
% Count cliques in the family of graphs and write these to files
% in a format useable by Perseus to compute filtered homology.
% ----------------------------------------------------------------

count_cliques_and_write_to_file(filteredCCGGraphs, ...
    Parameters.Dimension, 'data'. ''. 0);

% ----------------------------------------------------------------
% Use Perseus to compute persistent homology
% ----------------------------------------------------------------

system(sprintf('%s/perseus nmfsimtop data_simplices.s data_homology.s',...
    Parameters.PerseusDirectory));
