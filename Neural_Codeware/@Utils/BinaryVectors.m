function mtx = BinaryVectors(iLength)
    %------------------------------------------------------------
    % Usage:
    %    mtx = BinaryVectors(iLength)
    % Description:
    %    Returns a matrix whose rows are the binary vectors of
    %    the given length.
    % Arguments:
    %    iLength
    %       The length of the vectors to be computed.
    %------------------------------------------------------------
    assert(isscalar(iLength), 'Input must be a scalar.');
    assert(floor(iLength) == iLength, 'Input must be integer-valued');

    if iLength == 1
        mtx = [0; 1];
    else
        mtxSmaller = Utils.BinaryVectors(iLength - 1);

        mtx = [zeros(2^(iLength - 1), 1), mtxSmaller; ...
               ones(2^(iLength - 1), 1), mtxSmaller];
    end
end