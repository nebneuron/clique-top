function mtxGen = HammingMatrix(r)
    %---------------------------------------------------------------------------
    % Usage:
    %    mtxGen = LinearCode.HammingMatrix(r)
    % Description:
    %    Return a generator matrix for [2^r - 1, 2^r - r - 1] the Hamming code.
    % Arguments:
    %    r
    %       The resultant matrix will have 2^r - r - 1 columns.
    %---------------------------------------------------------------------------
    
    assert(r > 1, 'The argument must be an integer greater than 1.');

    % If $H = [A^T | I_{n-k}]$ is a parity-check matrix, then $G = [I_k | -A]$
    % is a generator matrix for the same code.  We use this method to create
    % a generator matrix.
    
    % We first want to compute `A` from above.  We initialize this to be a
    % matrix whose columns are the binary vectors of length `r`; this is
    % because a matrix whose rows are the nonzero binary vectors of this
    % length is a parity-check matrix for the desired Hamming code.
    A = Utils.BinaryVectors(r);
    
    % Remove the all-zero row and the vectors of weight one (which could be
    % stacked to form the identity matrix $I_{n-k}$ from above).  Also,
    % remove the all-zero column.
    A(sum(A, 2) < 2, :) = [];
    
    % We can now create the generator matrix referenced above.  Negating A is
    % not necessary since we're working over GF(2).
    mtxGen = [eye(2^r - r - 1), A];
end