function RemoveElts(this, cllnSets)
    %--------------------------------------------------------------------------------
    % Usage:
    %    clln.RemoveElts(cllnSets)
    % Description:
    %    Removes all elements of the calling object that are also
    %    elements of the given collection.
    % Arguments:
    %    cllnSets
    %       A `Collection` object of the same dimension as the calling object.
    %--------------------------------------------------------------------------------

    assert(n(this) == n(cllnSets), ...
           '`Collection` objects must have the same dimension.');

    this.Sets = setdiff(ToMatrix(this), ToMatrix(cllnSets), 'rows');
end