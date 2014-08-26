function mtxSubsets = SubsetsOfSize(vecIn, iSize)
    %------------------------------------------------------------
    % Usage:
    %    mtxSubsets = Utils.SubsetsOfSize(vecIn, iSize)
    % Description:
    %    Returns a matrix whose rows correspond to the subsets of the given
    %    size of the nonzero entries of the input vector.  For example, if the
    %    input vector is `[0 1 1 1]` and the given size is `2`, then the return
    %    value will be `[0 1 1 0; 0 1 0 1; 0 0 1 1]` or some row-permutation
    %    thereof.
    % Arguments:
    %    vecIn
    %       The input vector.
    %    iSize
    %       The size of the subsets to return.  This will be the number of
    %       nonzero entries in each row of the returned matrix.
    %------------------------------------------------------------

    if (length(find(vecIn, iSize)) < iSize)
        mtxSubsets = zeros(0, length(vecIn));
    else
        % Create the list of subsets of the vertices in this facet.
        mtxRowIndices = nchoosek(find(vecIn), iSize);
        iSets = size(mtxRowIndices, 1);
        mtxLinearIndices = iSets * (mtxRowIndices - 1) + repmat((1 : iSets).', 1, iSize);

        mtxSubsets = zeros(iSets, length(vecIn));
        mtxSubsets(mtxLinearIndices(:)) = 1;
    end
end