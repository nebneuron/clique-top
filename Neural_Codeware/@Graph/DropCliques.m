function gphRand = DropCliques(iSize, iCliqueSize, iNumCliques)
    mtxAdj = zeros(iSize);

    for i = (1 : iNumCliques)
        rvPerm = randperm(iSize);
        rvClique = rvPerm(1 : iCliqueSize);

        mtxAdj(rvClique, rvClique) = 1;
    end

    % There are non-zero diagonal entries in this matrix,
    % but we don't need to worry abou them because the
    % graph constructor takes care of this issue.
    gphRand = Graph(mtxAdj);
end