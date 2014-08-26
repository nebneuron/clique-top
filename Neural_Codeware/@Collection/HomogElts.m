function mtxElts = HomogElts(this, iSize)
    %--------------------------------------------------------------------------------
    % Usage:
    %    mtxElts = this.HomogElts(iSize)
    % Description:
    %    Return a matrix containing all elements of this collection that
    %    are of the given size.
    % Arguments:
    %    iSize
    %       The size of the elements to be returned.  The returned matrix
    %       will have this many columns.
    %--------------------------------------------------------------------------------
    
    cvIdxs = (sum(this.Sets, 2) == iSize);
    mtxElts = zeros(nnz(cvIdxs), iSize);
    
    for i = 1 : find(cvIdxs)
        mtxElts(i, :) = find(this.Sets(i, :));
    end
end