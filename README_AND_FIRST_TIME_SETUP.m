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
% CliqueTop currently relies on other software packages, which
% are included in this archive for ease of use. They are:
%
%  - Cliquer by Sampo Niskanen, based on algorithms developed by 
%       Patric Östergård, officially housed at 
%       http://users.tkk.fi/pat/cliquer.html.
%  - Perseus 4.0B by Vidit Nanda, currently available at 
%       http://www.sas.upenn.edu/~vnanda/perseus/index.html.
%  - Neural_Codeware by Zachary Roth, available at 
%       https://github.com/nebneuron/neural-codeware
%
% Installation Instructions: -------------------------------------
%
% In order to run the CliqueTop package, you must first compile 
% the MEX version of +Cliquer. If you have extracted the archive
% and all subfolders into this directory, simply run this script 
% to do so.
%
% If you encounter compilation errors, try the following:
%
% Change the MATLAB active directory to ./Neural_Codeware/mex_test
% Enter 'mex hello_world.c'
% 
% If the compilation of this program completes successfully, you 
% should now be able to type 'hello_world' and recieve a response.
% In this case, you are encountering an unknown setup error and we
% would be pleased to help you repair it.
%
% If not, the MEX compiler on your computer is mis-configured. In
% that case, please see your MATLAB documentation for assistance
% in reparing the configuration.
%
% It is also possible that you may not have exection permission
% for the Perseus program when you first expand the archive. 
% This can be resolved by entering the perseus subdirectory and
% adding execution permission for the version of Perseus that
% works with your operating system.
% 
% Usage: ---------------------------------------------------------
%
% Once the installation is complete, the primary interface for 
% using the package is the function
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

startFolder = cd(fileparts(which('compute_clique_topology.m')));
cd('Neural_Codeware');

Cliquer.Compile();

cd(startFolder);
