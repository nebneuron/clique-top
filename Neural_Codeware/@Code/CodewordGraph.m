function gph = CodewordGraph(this, tol)
    %---------------------------------------------------------------------------
    % Usage:
    %    gph = this.CodewordGraph(tol)
    % Description:
    %    Create a graph whose vertices correspond to the words of this code.
    %    Vertices are joined by an edge when the corresponding codewords are
    %    at most the given Hamming distace apart.
    % Arguments:
    %    tol (default: 1)
    %        The Hamming distance tolerance
    %---------------------------------------------------------------------------
    
    mtxWords = ToMatrix(this.Words);

    if nargin < 2
        tol = 1;
    end

    % The vertices should be the codewords of the graph, and we should join
    % words if their Hamming distance is at most `tol`.
    mtxHamming = mtxWords * (~mtxWords)' + (~mtxWords) * mtxWords';
    gph = Graph(mtxHamming <= tol);
end