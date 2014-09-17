function RemoveEltsContainedIn(this, cllnSets)
    %--------------------------------------------------------------------------------
    % Usage:
    %    clln.RemoveEltsContainedIn(cllnSets)
    % Description:
    %    Removes all elements of the calling object that are subsets of any
    %    of the elements of the given collection.
    % Arguments:
    %    cllnSets
    %       A `Collection` object of the same dimension as the calling object.
    %--------------------------------------------------------------------------------

    assert(n(this) == n(cllnSets), ...
           '`Collection` objects must have the same dimension');

    mtxThis = ToMatrix(this);
    mtxThis(max(mtxThis * ToMatrix(cllnSets).', [], 2) == sum(mtxThis, 2), ...
            :) = [];
    this.Sets = mtxThis;
end