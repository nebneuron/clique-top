function gphRand = Random(iSize, fSparsity)
    %--------------------------------------------------------------------------
    % Usage:
    %    gphRand = Graph.Random(iSize, fSparsity)
    % Description:
    %    Create a random graph of the given size and sparsity.
    % Arguments:
    %    iSize
    %       The number of vertices in the returned graph.
    %    fSparsity
    %       A number between 0 and 1.
    %--------------------------------------------------------------------------

    assert(0 < fSparsity && fSparsity < 1, ...
        'The given sparsity must be between 0 and 1');

    mtxAdj = triu(rand(iSize) < fSparsity, 1);
    mtxAdj = mtxAdj + mtxAdj.';

    gphRand = Graph(mtxAdj);
end