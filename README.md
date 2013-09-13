README: CliqueTop
===

CliqueTop is a collection of matlab scripts for doing topological analysis of correlation data. It was initially designed to study the persistent homology of cross-correlations between neuron spike recordings, but it can easily be adapted to work with any data correlation matrices.

The scripts are currently separated into three groups: those which accept as input neural spike train data and output cross-correlogram arrays, located in the folder data_to_ccgs; those which accept as input CCG arrays and output various topological invariants and controls, located in ccg_computations; and those which either produce some sort of visualization of the output or are utilities for doing so, located in create_figures.

CliqueTop currently relies on other software packages, which must be installed in order for the process to function correctly: 

 * For clique handling in CCG graphs, we require that the packages in nebneuron/neural-codeware and nebneuron/matlab-cliquer be available. Please follow the installation instructions found at at https://github.com/nebneuron/neural-codeware and https://github.com/nebneuron/matlab-cliquer respectively. Matlab-cliquer is based on Cliquer, a fast clique counting software package written by Sampo Niskanen based on algorithms developed by Patric Östergård, officially housed at http://users.tkk.fi/pat/cliquer.html.
 * For persistent homology computations, we make use of Perseus by Vidit Nanda. It is currently available at http://www.math.rutgers.edu/~vidit/perseus/index.html.
