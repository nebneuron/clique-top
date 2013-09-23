% ----------------------------------------------------------------
% PRODUCE BASIC BETTI CURVE FIGURE
%
% Given a Perseus output file containing betti numbers from a 
% filtration, construct a graph. This script is intended to
% demonstrate use of the draw_betti_curves function.
%
% This script assumes that a maximal CCG matrix and all 
% associated data has been loaded using the script 
% SETUP COMPUTATIONS or an equivalent process.
% ----------------------------------------------------------------

clear all;
clc;
close all;

% ----------------------------------------------------------------
% Set necessary parameters to draw the figure.
% ----------------------------------------------------------------

Parameters.PStep = 0.01;   % filtration parameter (graph density)
Parameters.MaxP = 0.5;     % step and maximum to display

Parameters.NumFiltrations = Parameters.MaxP/Parameters.PStep+1;

Parameters.Dimension = 4;  % maximum homological dimension 

% ----------------------------------------------------------------
% Describe file name of Perseus output file. If the file was 
% produced by the scripts in the CCG COMPUTATIONS folder
% then simply use the same settings found there
% ----------------------------------------------------------------

Parameters.FilePrefix = 'data'; % File name of Perseus output file
Parameters.FileSuffix = '';	% is of the form:
Parameters.NumRuns = 20;        %   <Parameters.Prefix>_homology<Parameters.Suffix>_<run_number>.s_betti.txt
   		                % or
                                %   <Parameters.Prefix>_homology<Parameters.Suffix>.s_betti.txt
		                % if Parameters.NumRuns is zero.

% ----------------------------------------------------------------
% Parameters for graphics: line style, line width and 
% colors of Betti curves. Default: Betti 1 is Blue, Betti 2 is Red
% Betti 3 is Green and Betti 4 is Magenta.
% ----------------------------------------------------------------

Parameters.LineStyle = '-';
Parameters.LineWidth = 1;
Parameters.ColorProgression=[[0,0,1]; [1,0,0]; [0,1,0]; [1,0,1]];



figure;
graphicsHandle = axes;

hold on;

draw_betti_curves(Parameters.FilePrefix, Parameters.FileSuffix,...
        Parameters.NumRuns, Parameters.PStep, Parameters.MaxP, ...
        Parameters.Dimension, Parameters.LineStyle, ...
        Parameters.LineWidth, graphicsHandle, ...
	Parameters.ColorProgression);

