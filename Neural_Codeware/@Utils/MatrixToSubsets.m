function celSubsets = MatrixToSubsets(mtxSubsets)
    %------------------------------------------------------------
    % Usage:
    %    mtxSubsets = Utils.MatrixToSubsets(mtxSubsets)
    % Description:
    %    Returns a cell array representation of the logical (0/1) input matrix
    % Arguments:
    %    mtxSubsets
    %       A 0/1 matrix whose rows represent subsets of its columns.
    % Note:
    %    No checking is done to make sure that the subsets returned are unique.
    %------------------------------------------------------------

    iNumSubsets = size(mtxSubsets, 1);
    celSubsets = cell(iNumSubsets, 1);

    for ii = (1 : iNumSubsets)
        celSubsets{ii} = find(mtxSubsets(ii, :));
    end
end