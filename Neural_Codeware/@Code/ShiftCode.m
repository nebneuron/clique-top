function code = ShiftCode(n, k)
    %---------------------------------------------------------------------------
    % Usage:
    %    code = Code.ShiftCode(n, k)
    % Description:
    %    Create a code whose entries are all circular shifts of the vector
    %    `[ones(1, k), zeros(1, n - k)]`.
    % Arguments:
    %    n
    %        The length of the resultant code.
    %    k
    %        The number of nonzero entries in each codeword.
    %---------------------------------------------------------------------------
    
    rv = zeros(1, n);
    cv = zeros(1, n);

    rv(n - k + 1 : end) = 1;
    cv(2 : k + 1) = 1;

    code = Code(toeplitz(cv, rv));
end