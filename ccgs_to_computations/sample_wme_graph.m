function [ edgeWeights ] = sample_wme_graph( theta )

% ----------------------------------------------------------------
% SAMPLE WME GRAPH
%
% Given parameter vector theta of n entries describing a maximum 
% entropy distribution on non-negatively weighted graphs, sample
% an element from that distribution.
%
% INPUTS: 
%   theta: a vector of parameters which describes the maximum
%       entropy distribution on weighted graphs
%
% OUTPUTS:
%   edgeWeights: an adjacency matrix for a nonnegatively weighted
%       graph sampled from the given maximum entropy distribution
% ----------------------------------------------------------------


% ----------------------------------------------------------------
% Compute the mean weights from the parameters theta. Since each
% edge is independently sampled from an exponential distribution
% these values describe the distribution
% ----------------------------------------------------------------

n = length(theta);
meanMatrix = zeros(n);
for i=1:n
    for j=i+1:n
        meanMatrix(i,j) = 1/(theta(i)+theta(j));
        meanMatrix(j,i) = meanMatrix(i,j);
    end
end

% ----------------------------------------------------------------
% Sample the upper-triangular entries in the adjacency matrix, 
% then symmetrize
% ----------------------------------------------------------------

edgeWeights = exprnd(meanMatrix);

for i=1:n
    edgeWeights(i,i) = 0;
    for j=i+1:n
        edgeWeights(j,i) = edgeWeights(i,j);
    end
end

end