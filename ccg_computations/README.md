README: CCG COMPUTATIONS
==


This collection of scripts and functions is designed to accept 
as input a "maximal" cross-correlogram, build a filtered family
of graphs compute betti curves (and persistent homology) of
that family. 

There are several additional scripts which compute graph 
laplacians and various controls for the given dataset as well.
These should be run following the initial data computation, as 
they rely on various components thereof. Further, there is a 
script designed to be called by a scheduler on a cluster to
facilitate batch analyses.

In order to use these scripts, one must have the 
neural-codeware Cliquer and Graph classes installed, as well
as the Perseus persistent homology software package. 

The main scripts should be run in the following order:

  SETUP COMPUTATIONS

  BUILD FILTERED MATRICES AND COMPUTE BETTIS

The first script needs to be edited to reflect the settings
desired for the data file and controls before it is executed. 
The second script decomposes the CCG matrix into a thresholded
family of graphs, then uses Cliquer and Perseus to compute the 
persistent homology of the family of graphs.

There several optional scripts, which can be run after 
BUILD FILTERED MATRICES AND COMPUTE BETTIS is complete:

 * COMPUTE GRAPH LAPLACIANS

This script constructs graph Laplacians for both the weighted
graphs and the families of filtered binary matrices built from 
the data, as well as the spectra of such. 

 * BUILD SHUFFLED CCG CONTROLS AND COMPUTE BETTIS
 * BUILD WME CONTROLS AND COMPUTE BETTIS
 * BUILD GEOMETRIC GRAPH CONTROLS AND COMPUTE BETTIS

These scripts build controls from the CCG base matrix and then 
run the same filter/count cliques/compute betti curves process
on this family of controls to produce mean betti curves. The
shuffled CCG control shuffles the entries of the CCG matrix, 
destroying correlations between elements. The WME control samples
the maximum entropy distribution on weigthed graphs given by 
"observing" the CCG matrix. The geometric graph control drops
points (uniformly) in euclidean space and uses the inverse of
their distances to simulate correlations.

Lastly, the batch analysis script is
 
 * BATCH ANALYSIS

This script relies on an external file containing a cell array of
precomputed CCG matrices and needs to be passed a variable called
'iter' which controls which matrix the script runs the usual
analysis on.
