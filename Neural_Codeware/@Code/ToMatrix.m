function mtx = ToMatrix(this)
    %---------------------------------------------------------------------------
    % Usage:
    %    mtx = this.ToMatrix()
    % Description:
    %    Create a matrix representation of the codewords in this code in
    %    which each row of the matrix represents a single codeword vector.
    %---------------------------------------------------------------------------
    
    mtx = ToMatrix(this.Words);
end