function SetDistribution(this, cvDistribution)
    %---------------------------------------------------------------------------
    % Usage:
    %    this.SetDistribution(cvDistribution)
    % Description:
    %    Set the internal distribution of the codewords of this code.
    % Arguments:
    %    cvDistribution
    %        A column vector containing a distribution.  The entries in this
    %        vector must be positive and will be rescaled so that they sum to
    %        one.
    %---------------------------------------------------------------------------
    
    % More checking could be done here.  For instance, the current
    % checking allows for `NaN` and `Inf` values that will cause errors.
    assert(isa(cvDistribution, 'numeric'), ...
           'The input distribution must have a numeric type.');
    assert(iscolumn(cvDistribution), ...
           'The input distribution must be a column vector.');
    assert(length(cvDistribution) == this.Words.Size(), ...
           ['The input distribution must have length equal to the size ' ...
            'of the code.']);
    assert(min(cvDistribution) >= 0 && max(cvDistribution) >= 0, ...
           ['The input distribution must contain only nonnegative ' ...
            'values and at least one positive value.']);

    this.Distribution = cvDistribution / sum(cvDistribution);
end