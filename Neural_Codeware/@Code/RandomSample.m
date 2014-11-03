function cllnRand = RandomSample(this, iSize)
    %---------------------------------------------------------------------------
    % Usage:
    %    cllnRand = this.RandomSample(iSize)
    % Description:
    %    Use this code's internal distribution to create a `Collection`
    %    containing a random sample of the codewords in this code.
    % Arguments:
    %    iSize
    %        The number of codewords in the resulting collection; can be any
    %        positive integer.
    %---------------------------------------------------------------------------
    
    [~, I] = max(bsxfun(@le, ...
                    rand(iSize, 1), ...
                    cumsum(this.Distribution)), ...
                 [], 2);

    cllnRand = this.Words(I);
end