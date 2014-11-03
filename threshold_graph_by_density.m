function [ thresholdedGraph, remainingEdges ] =...
    threshold_graph_by_density( weightedGraph, density )

% ----------------------------------------------------------------
% THRESHOLD GRAPH BY DENSITY
% written by Chad Giusti, 6/2014
%
% Given the adjacency matrix for a weighted graph and a threhsold
% density, return the binary adjancency matrix with the target 
% density (or as close as possible below that density) whose edges
% are of highest possible weight for such a graph.
%
% INPUT:
%   weightedGraph: adjacency matrix for a  weighted graph.
%   density: Graph edge density for the target graph
%
% OUTPUT:
%   thresholdedGraph: Binary adjacency matrix 
%       for graph with  target edge density and maximal edge
%       weight sum
%   remainingEdges: a list of edges which are not included in
%       the thresholded graph, sorted in descending order
% ----------------------------------------------------------------

% ----------------------------------------------------------------
% Sort the edge weights so we can find the threshold, return 
% resulting binary graph
% ----------------------------------------------------------------

edgeWeights = weightedGraph(triu(ones(size(weightedGraph,1)),1)>0);
edgeWeights = sort(edgeWeights(:), 'descend');

thresholdIndex = ceil((density) * length(edgeWeights));
edgeWeightThreshold = edgeWeights(thresholdIndex);

thresholdedGraph = (weightedGraph >= edgeWeightThreshold);
remainingEdges = unique(edgeWeights(1:thresholdIndex), 'stable');

end

