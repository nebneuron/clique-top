README: CliqueTop
===

CliqueTop is a collection of matlab scripts for doing topological analysis of symmetric matrices. 

The syntax for using the package is 

compute_clique_topology(A)

for any symmetric matrix A. Options and details can be found in the documentation for the compute_clique_topology function.

CliqueTop currently relies on the following software packages, which are included in this repository for convenience and should function automatically without installation:

* For persistent homology computations, we make use of Perseus by Vidit Nanda. As of this writing, the current version can be found at http://www.sas.upenn.edu/~vnanda/perseus/index.html. We recommend using the snapshot provided in this repository, as the input/output format for Perseus may change in the future.
* Cliquer, for the clique splitting version of the clique enumeration algorithm, a C package by Sampo Niskanen and Patric R. J. Östergård, available at http://users.aalto.fi/~pat/cliquer.html.

The code was written by Chad Giusti, and the underlying ideas are the result of joint work with Vladimir Itskov and Carina Curto. The work was supported by NSF DMS-1122519. More details can be found in

  Giusti, Pastalkovaa, Curto and Itskov, "Clique topology reveals instrinsic geometric structure in neural correlations." 
  (arXiv:1502.06172 [q-bio.NC] and arXiv:1502.06173 [q-bio.NC])
