function cllnComplex = SimplicialComplex(this)
    %------------------------------------------------------------
    % Usage:
    %    cllnComplex = SimplicialComplex(this)
    % Description:
    %    Generate the smallest simplicial complex containing this
    %    collection.
    % Note:
    %    The algorithm used here is very naive.  It simply generates all
    %    subsets of each element and unions these sets together.  This is
    %    quite slow and memory inefficient.
    %------------------------------------------------------------

    % Retrieve a matrix representation of the facets.
    mtxElts = ToMatrix(this);

    % Create the initial list of elements to be the empty list.  If we find a
    % quick way to compute the number of elements without having to find all of
    % the elements, then preallocating here could be a good idea.  For now, we can
    % bound the number of elements; use this bound and keep track of the number of
    % elements as they're generated.
    iNumElementsBound = sum(2.^sum(mtxElts, 2));
    iNumElements = 0;
    mtxComplex = zeros(iNumElementsBound, NumElts(this));

    for ii = 1 : NumElts(this)
        % Get the matrix of subsets of this facet.
        mtxSubsets = Utils.SubsetsOf(mtxElts(ii, :));

        % Append the subsets of this facet to the list of elements.
        mtxComplex((iNumElements + 1 : iNumElements + size(mtxSubsets, 1)), :) = mtxSubsets;

        % Increment the number of elements.
        iNumElements = iNumElements + size(mtxSubsets, 1);
    end

    % Keep only the unique elementx.
    cllnComplex = Collection(unique(mtxComplex((1 : iNumElements), :), 'rows'));
end