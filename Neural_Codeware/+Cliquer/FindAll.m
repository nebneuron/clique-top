%--------------------------------------------------------------------------
% Usage:
%    [iNumCliques, mtxCliques] = Cliquer.FindAll(mtxAdj, iMinSize,
%       iMaxSize, bOnlyMaximal, iMaxNumCliques)
% Description:
%    Find all of the cliques of a given size in the graph represented by
%    (the upper-triangular portion of) the input matrix.
% Arguments:
%    mtxAdj
%       An adjacency matrix for a graph.
%    iMinSize
%       The minimum size of the cliques to be found.  Must be positive.
%    iMaxSize
%       The maximum size of the cliques to be found.  Must be
%       nonnegative.  Set to zero to have no upper bound on clique
%       size.
%    bOnlyMaximal
%       A logical input that is `true` if only maximal cliques should be
%       counted and `false` if all cliques should be counted.
%    iMaxNumCliques
%       The maximum number of cliques to be returned by this function. I
%       believe that this is necessary due to a limitation of Cliquer. Note
%       that the correct total number `iNumCliques` is returned even if
%       `iMaxNumCliques` is smaller.
% Return values:
%    iNumCliques
%       The total number of cliques within the range of sizes.
%    mtxCliques
%       The matrix of actual cliques found (up to `iMaxNumCliques` only).
%--------------------------------------------------------------------------

% THIS IS JUST A DUMMY FILE SO THAT WE CAN HAVE APPROPRIATE
% DOCUMENTATION OF THE C-CODE BY THE SAME NAME!