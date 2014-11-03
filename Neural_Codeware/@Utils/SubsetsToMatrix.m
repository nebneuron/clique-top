function mtxSubsets = SubsetsToMatrix(cellSubsets, iSetSize)
    %------------------------------------------------------------
    % Usage:
    %    mtxSubsets = Utils.SubsetsToMatrix(cellSubsets, iSetSize)
    % Description:
    %    Returns a matrix whose rows are indicator vectors for
    %    the subsets in the given cell array.
    % Arguments:
    %    cellSubsets
    %       A cell array whose entries are row vectors (sets).  The maximum
    %       number among entries determines the number of columns of the
    %       returned matrix.
    %    iSetSize
    %       The size of the superset of these subsets (or the total
    %       number of neurons).
    % Note:
    %    No checking is done to make sure that the subsets are unique.
    %------------------------------------------------------------

    iNumSubsets = size(cellSubsets, 1);
    iMax = max([cellSubsets{:}]);

    if nargin < 2
        iSetSize = iMax;
    end

    assert(iMax <= iSetSize);

    mtxSubsets = zeros(iNumSubsets, iSetSize);

    for ii = (1 : iNumSubsets)
        mtxSubsets(ii, cellSubsets{ii}) = 1;
    end
end