function [iVerts, iEdges] = Size(this)
    iVerts = size(this.AdjacencyMatrix, 1);
    iEdges = nnz(this.AdjacencyMatrix) / 2;
end