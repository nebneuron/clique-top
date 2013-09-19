% ----------------------------------------------------------------
% BATCH ANALYSIS
%
% This script is a 'batch' tool designed to be launched by the
% a scheduler to concurrently execute a collection of related
% analyses. The CCG matrices to be analyzed should be moved
% to the cell array ccg_trials, where they will be iterated over
% by columns then rows. Output will written into the working
% directory in perseus input/output files with suffix '_row_col'.
% 
% The script should be called after SETUP COMPUTATIONS or a
% similar script which sets the usual parameters. However, be 
% certain to comment out the CCG File location/name in SETUP 
% COMPUTATIONS, as these are not needed.
%
% It is vital that the script that calls this one set the 
% variable 'iter'.
% ----------------------------------------------------------------

% ----------------------------------------------------------------
% Load the CCG matrices from a .mat file, standardize notation and
% choose the appropriate matrix to work with. Be sure to change
% both the file name to load and the variable name of the matrix.
% ----------------------------------------------------------------

load('/home/mathneuro/cgiusti/Datasets/coh_subject_trial_blocks_GM.mat');

ccg_trials = coh_subj_trial_blocks;

numRows = size(ccg_trials, 2);

row = floor((iter-1)/numRows) + 1;
col = mod((iter-1), numRows) + 1;

disp(sprintf('iter: %i, row: %i, col: %i', iter, row, col));

thisCCGMatrix = ccg_trials(row, col);

Parameters.FilePrefix = 'batch'
Parameters.FileSuffix = sprintf('_%i_%i',row,col)

% ----------------------------------------------------------------
% Perform analysis on selected CCG graph
% ----------------------------------------------------------------

filteredCCGGraphs = weighted_graph_to_p_thresholded_graphs(...
   thisCCGMatrix, Parameters.PStep, Parameters.MaxP);

count_cliques_and_write_to_file(filteredCCGGraphs, ...
    Parameters.Dimension, Parameters.FilePrefix,...
    Parameters.FileSuffix, 0);

run_perseus(Parameters.FilePrefix, Parameters.FileSuffix, 0, ...
    Parameters.PerseusDirectory);

