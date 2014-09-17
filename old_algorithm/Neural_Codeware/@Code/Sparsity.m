function s = Sparsity(this)
    %---------------------------------------------------------------------------
    % Usage:
    %    s = this.Sparsity()
    % Description:
    %    Get the sparsity of this code, i.e., the percentage of entries that
    %    are expected to be nonzero on average.
    %---------------------------------------------------------------------------
    
    s = nnz(ToMatrix(this)) / (Size(this) * Length(this));
end