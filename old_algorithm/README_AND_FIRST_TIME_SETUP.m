% ----------------------------------------------------------------
% CliqueTop Package
% README AND FIRST TIME SETUP 
% written by Chad Giusti, 6/2014
% contact: cgiusti2@unl.edu
%
% CliqueTop is a MATLAB package for doing topological analysis of 
% correlation data. It was initially designed to study the 
% persistent homology of cross-correlations between activity of
% neurons in a population, but it computes invariants of general 
% symmetric real matrices under element-wise monotonic increasing 
% transformations. For details of what these invariants measure, 
% please see 
%   PAPER REFERENCE HERE 
%
% CliqueTop currently relies on Perseus for persistent homology
% computations, which is included in this archive for ease of use:
%
%  - Perseus 4.0B by Vidit Nanda, currently available at 
%       http://www.sas.upenn.edu/~vnanda/perseus/index.html.
%
% Usage: ---------------------------------------------------------
%
% The primary interface for using the package is the function
%
%   compute_clique_topology( inputMatrix )
%
% or
%
%   compute_clique_topology( inputMatrix, 'ParameterName', Param )
%
% which can be run on any symmetric matrix with real entries. 
% We recommend not running this process on matrices larger than 
% 100 x 100 unless your computer has substantial memory and 
% processing power, as clique enumeration is part of this process.
% Depending on the size and structure of the matrix, computations 
% can take several days. 
%
% By default, the function's first output will be a matrix with 
% three columns, respectively the first through third Betti curves
% of the order complex for the matrix on the density range [0, 0.6].
% The function also produces persistence lifetime information, as
% secondary output arguments.
%
% For details on optional parameters for the clique topology 
% computation, see the documentation of the compute_clique_topology
% function.
% ----------------------------------------------------------------
