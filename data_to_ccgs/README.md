README: DATA TO CCGS
==

This collection of scripts and functions is designed to turn 
spike train data into 3D cross-correlogram arrays. There are 
three scripts, which should be run in the following order:

  SET CCG PARAMETERS AND LOAD DATA FILE

  PREPROCESS DATA
 
  BUILD MAXIMAL CCG MATRIX

The first script needs to be edited to reflect the settings
appropriate to the data file being processed before it is 
executed. The second script contains a large number of specific
case preprocessing steps designed to standardize variable names
and data formats, as well as to cull the population of neurons
to those that fit our experimental parameters. The last script
turns the preprocessed data into the CCG array and stores the
data necessary for the primary data analysis to run. 

