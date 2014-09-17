function gphComp = Complement(this)
    %--------------------------------------------------------------------------
    % Usage:
    %    gphComp = obj.Complement()
    % Description:
    %    Return the complement of the calling graph.
    %--------------------------------------------------------------------------

    mtxAdj = ToMatrix(this);
    mtxAdj = 1 - mtxAdj;
    mtxAdj(1 : n+1 : n^2) = 0;

    gphComp = Graph(mtxAdj);
end