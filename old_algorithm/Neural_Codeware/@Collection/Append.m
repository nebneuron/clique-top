function Append(this, cllnNew)
    %--------------------------------------------------------------------------------
    % Usage:
    %    obj.Append(cllnNew)
    % Description:
    %    Appends the argument to the calling object.
    % Arguments:
    %    cllnNew
    %       A `Collection` object of the same dimension as the calling object.
    %--------------------------------------------------------------------------------
    
    if n(this) ~= n(cllnNew)
        error('The dimension of the `Collection` objects must agree.');
    end

    this.Sets = [this.Sets; cllnNew.Sets];
end