% ----------------------------------------------------------------
% SETUP COMPUTATIONS
%
% Set parameters and load/prepare CCG matrix for computations
%
% This section is specific to the data being used and needs to be 
% modified as appropriate for different applications.
%
% In this case, we load a "maximal CCG matrix" computed over a 10
% second window range from spike train data, then pare it down to 
% the window range we require, average and normalize activity over
% the window to obtain a weighted graph of activity correlations.
% ----------------------------------------------------------------

% ----------------------------------------------------------------
% Set the CCG File location and name
% ----------------------------------------------------------------

cd('~/CCGs');
load('g01_maze14_MS.003_DataStructure_mazeSection13_TrialType1_whlDirCW_CCG.mat');

Parameters = Par;

Parameters.CCGWindowWidth = 1;

% ----------------------------------------------------------------
% Set graph denstiy filtration range, maximal betti number (dimension)
% to compute and number of controls to run
% ----------------------------------------------------------------

Parameters.Dimension = 4;

Parameters.AnalysisType = 'CCG';

Parameters.PStep = 0.01;
Parameters.MaxP = 0.5;      
Parameters.numFiltrations = floor(Parameters.MaxP/Parameters.PStep) + 1;

Parameters.numControls = 20;

% ----------------------------------------------------------------
% Perseus location
% ----------------------------------------------------------------

Parameters.PerseusDirectory = '~/Code/perseus';

% ----------------------------------------------------------------
% Define and create/clear working directory.
% ----------------------------------------------------------------

Parameters.WorkDirectory = ...
    '~/results/spectrum_g01_maze14_MS.003';

if (exist(Parameters.WorkDirectory,'dir'))
    cd(Parameters.WorkDirectory);
    remove_files = dir;
    for k = 3:length(remove_files)
        delete(remove_files(k).name);
    end
    cd(Parameters.WorkDirectory);
else             
    mkdir(Parameters.WorkDirectory);
    cd(Parameters.WorkDirectory);
end
