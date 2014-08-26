function mtxGen = GolayMatrix()
    %---------------------------------------------------------------------------
    % Usage:
    %    mtxGen = LinearCode.GolayMatrix()
    % Description:
    %    Create a generator matrix for the (binary) Golay code of length 24.
    % Note:
    %    The construction used here is taken from "Fundamentals of
    %    Error-Correcting Codes" by W. C. Huffman and V. Pless.
    %---------------------------------------------------------------------------
    
    % I would have just hard-coded the generator matrix, but this seemed
    % easier and less likely to contain an error.

    % The 'hankel(c, r)' command produces a matrix that is constant on its
    % anti-diagonals, where 'c' and 'r' are the first column and last row,
    % respectively, of this matrix.
    v = [1 1 0 1 1 1 0 0 0 1 0];
    A = hankel(v, v([11, 1:10]));
    mtxGen = [eye(12), [0, ones(1, 11);
                        ones(11, 1), A]];
end