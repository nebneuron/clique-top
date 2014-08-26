function mtxSets = ToMatrix(this)
    %--------------------------------------------------------------------------------
    % Usage:
    %    mtxSets = obj.ToMatrix()
    % Description:
    %    Return a (sparse) binary matrix representation of a set.  Entry (i, j)
    %    of the returned matrix will be 1 if set i contains element j and will
    %    be 0 otherwise.
    %--------------------------------------------------------------------------------

    mtxSets = this.Sets;
end