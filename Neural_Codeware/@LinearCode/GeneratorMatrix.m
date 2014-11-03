function mtxGen = GeneratorMatrix(this)
    %---------------------------------------------------------------------------
    % Usage:
    %    mtxGen = this.GeneratorMatrix()
    % Description:
    %    Return the matrix used to generate the calling `LinearCode` object.
    %---------------------------------------------------------------------------
    
    mtxGen = this.GenMtx;
end