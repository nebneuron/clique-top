% ----------------------------------------------------------------
% SET CCG PARAMETERS AND LOAD DATA FILE
%
% Set up parameters for computation of maximal CCG from a data
% file. These parameters are standardized across the analysis
% outside of the input file name and should not be changed.
% ----------------------------------------------------------------

clc;
clear all;

% ----------------------------------------------------------------
% Note the analysis type we're doing and the type of data file
% for preprocessing purposes, as well as the name of the data
% file from which to draw our data.
% ----------------------------------------------------------------

Parameters.AnalysisType = 'CCG_pThresh';
Parameters.DataType='WHEEL_CONCAT';

Parameters.InputFileName='~/Datasets/hippocampal/maze/g01_maze13_MS.001_DataStructure_mazeSection13_TrialType1_whlDirCW.mat';
[inFilePath, inFileName] = fileparts(Parameters.InputFileName);

% ----------------------------------------------------------------
% Default sampling frequency. This will be overrridden if 
% provided by the data file in a recognized field
% ----------------------------------------------------------------

Parameters.SamplingFrequency = 1250;

% ----------------------------------------------------------------
% Minimum/maximum firing rate in Hz for a cell 
% cells outside this range are discarded, and minimum number
% of cells to allow in a dataset after preprocessing.
% ----------------------------------------------------------------

Parameters.MinFiringRate = 0.2; 
Parameters.MaxFiringRate = 7;   

Parameters.cellThreshold = 50;

% ----------------------------------------------------------------
% Sleep-data specific parameters. Uncomment to run sleep data.
% ----------------------------------------------------------------
% Parameters.SleepStartTime =570;
% Parameters.SleepEndTime = 630;

% ----------------------------------------------------------------
% Indicate the maximum CCG window width we're gonig to compute.
% ----------------------------------------------------------------

Parameters.maxCCGWindowWidth = 5;
    
% ----------------------------------------------------------------
% Load the specified data file  
% ----------------------------------------------------------------

try
    load(sprintf(Parameters.InputFileName));
catch exception
    disp(sprintf('File load failed: %s', exception.message));
end

