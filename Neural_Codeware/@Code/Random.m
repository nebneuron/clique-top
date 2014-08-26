function clln = Random(iLength, iSize, fSparsity)
    %---------------------------------------------------------------------------
    % Usage:
    %    clln = Code.Random(iLength, iNumWords, fSparsity)
    % Description:
    %    Create a random code of the given length, size, and sparsity.
    % Arguments:
    %    iLength
    %        The length of the resultant code.
    %    iSize
    %        The size of the resultant code.
    %    fSparsity
    %        The sparsity of the resultant code.
    %---------------------------------------------------------------------------
    
    assert(iNumWords < 2^iLength, ...
        'First and second arguments are not compatible.')

    % Generate a random code, and remove repeated codewords.
    mtxCode = unique(rand(iNumWords, iLength) < fSparsity, 'rows');

    % If there are not enough unique codewords, generate more codewords
    % until enough codewords have been generated.
    while size(mtxCode, 1) < iNumWords
        temp = (rand(iNumWords, iLength) < fSparsity);
        mtxCode = unique([mtxCode; temp], 'rows');
    end

    % The above process could have produced too many codewords; select
    % only the first `iNumWords` that were generated.
    mtxCode = mtxCode(1:iNumWords, :);
    clln = Code(mtxCode);
end