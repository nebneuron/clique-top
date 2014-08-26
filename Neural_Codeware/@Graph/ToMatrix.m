function mtxAdj = ToMatrix(this)
    %--------------------------------------------------------------------------
    % Usage:
    %    mtxAdj = obj.ToMatrix()
    % Description:
    %    Return the adjacency matrix of the calling graph.
    %--------------------------------------------------------------------------

    mtxAdj = full(this.AdjacencyMatrix);
end