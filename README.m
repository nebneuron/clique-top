% ----------------------------------------------------------------
% CliqueTop Package
% README 
% written by Chad Giusti, 9/2014
% contact: cgiusti@seas.upenn.edu
%
% CliqueTop is a MATLAB package for doing topological analysis of 
% correlation matrices. It was initially designed to study the 
% persistent homology of cross-correlations between activity of
% neurons in a population, but it computes invariants of general 
% symmetric real matrices under element-wise monotonic increasing 
% transformations. For details of what these invariants measure, 
% please see 
%   Giusti, Pastalkova, Curto, Itskov, "Clique topology reveals 
%   intrinsic structure in neural correlations"
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
%
% Algorithms: ----------------------------------------------------
%
% There are three algorithms for clique enumeration implemented
% in this package. By default, a naive algorithm that does not 
% enumerate maximal cliques is used. This algorithm is less memory
% intensive, but does not allow for maximal clique statistics and 
% may be slower in some cases. The algorithm used in the paper 
% cited above was the 'split' algorithm, which can be used
% by selecting the appropriate parameter, as detailed in the 
% documentation.
%
% ----------------------------------------------------------------
