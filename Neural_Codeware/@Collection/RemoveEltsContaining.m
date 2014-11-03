function RemoveEltsContaining(this, cllnSets)
    %--------------------------------------------------------------------------------
    % Usage:
    %    clln.RemoveEltsContaining(cllnSets)
    % Description:
    %    Removes all elements of the calling object that are supersets of any
    %    of the elements of the given collection.
    % Arguments:
    %    cllnSets
    %       A `Collection` object of the same dimension as the calling object.
    %--------------------------------------------------------------------------------

    assert(n(this) == n(cllnSets), ...
           '`Collection` objects must have the same dimension');

    % Retrieve the matrices corresponding to the sets.
    mtxThis = ToMatrix(this);
    mtxToRemove = ToMatrix(cllnSets);

    % This product computes the size of the pairwise intersections of the
    % calling object's elements with the elements to be removed.
    mtxNumEltsInCommon = mtxThis * mtxToRemove.';

    % Build a matrix whose columns are constant-valued; more specifically,
    % column `i` of the matrix contains (in each entry) the weight of the
    % element `i` of `cllnSets`.
    mtxNumEltsPerSet = ones(Size(this), 1) * sum(mtxToRemove, 2).';

    % Now, if |A \cap B| is equal to |B| for an element A of `this` and an
    % element B of `cllnSets`, then B is a subset of A.  In this case, we want
    % to remove A from `this`.
    mtxThis(any(mtxNumEltsInCommon == mtxNumEltsPerSet, 2), :) = [];

    % Set the generators in this object to be the unique elements of `mtxThis`.
    this.Sets = mtxThis;
end