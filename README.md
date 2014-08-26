README: CliqueTop
===

CliqueTop is a collection of matlab scripts for doing topological analysis of symmetric matrices.

When you first download CliqueTop, please run the script 

README_AND_FIRST_TIME_SETUP.m

to compile the Neural Codeware MEX interface to Cliquer (see below). Once this is complete, the syntax is 

compute_clique_topology(A)

for any symmetric matrix A. Options and details can be found in the documentation for the compute_clique_topology function.

CliqueTop currently relies on the following software packages, which are included in this repository for convenience and should require no further installation after running the included first time setup file:

 * For clique handling in CCG graphs, we use the packages in nebneuron/neural-codeware. Matlab-cliquer is based on Cliquer, a fast clique counting software package written by Sampo Niskanen based on algorithms developed by Patric Östergård, officially housed at http://users.tkk.fi/pat/cliquer.html.
 * For persistent homology computations, we make use of Perseus by Vidit Nanda. As of this writing, the current version can be found at http://www.sas.upenn.edu/~vnanda/perseus/index.html. We recommend using the snapshot provided in this repository, as the input/output format for Perseus may change in the future.
