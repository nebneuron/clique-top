function v = FVector(this)
    %------------------------------------------------------------
    % Usage:
    %    v = clln.FVector()
    % Description:
    %    Compute a vector `v` of length `clln.n()` so that `v(i)` is the
    %    number of elements of size `i` in this collection.
    %------------------------------------------------------------

    v = histc(sum(ToMatrix(this), 2), 1 : this.NumVerts);
end