function SetWeights(this, cvWeights)
    %--------------------------------------------------------------------------------
    % Usage:
    %    clln.SetWeights(cvWeights)
    % Description:
    %    Assign a weight to each element of this collection.
    % Arguments:
    %    cvWeights
    %       A column vector containing a numeric weight for each element of
    %       this collection.
    %--------------------------------------------------------------------------------
    
    assert(iscolumn(cvWeights));
    assert(isnumeric(cvWeights));
    assert(NumElts(this) == length(cvWeights));

    this.Weights = cvWeights;
end