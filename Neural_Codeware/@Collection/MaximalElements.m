function cllnMaximal = MaximalElements(this)
    %--------------------------------------------------------------------------------
    % Usage:
    %    cllnMaximal = clln.MaximalElements()
    % Description:
    %    Return a `Collection` of the maximal elements (under subset inclusion)
    %    of a `Collection` object.
    %--------------------------------------------------------------------------------

    % This needs to be made sippier and more memory efficient for, for
    % instance, the case that we are finding the maximal elements of a full
    % simplicial complex.  Use this comment for ideas.
    % 
    % The elements of maximum size are always maximal.  We can identify those
    % elements at low cost and then continue a search on the remaining
    % elements.
    % 
    % Using those maximal elements found above, we can use the algorithm below
    % (or some modification thereof) to reduce the search, specifically
    % eliminating those elements that are subsets of maximum elements.
    % 
    % We can then iterate the above process on the reduced collection.  Will
    % this be at all efficient?  That's unclear.  The overall time-complexity
    % is likely the same, but the amount of computation is likely reduced
    % (provided that the maximum sets are supersets of other many other sets).
    % Unfortunately, that doesn't actually mean that this method will be faster
    % since it involves a loop, which is slow in Matlab.

    % Initialize the matrix of sets remaining to be searched to be the entire
    % list of sets.  Initilize the matrix of maximal elements to be empty.
    mtxRemaining = ToMatrix(this);
    mtxMaximal = zeros(0, n(this));

    while (~isempty(mtxRemaining))
        % Find the maximum sets among those remaining.
        cvEltOrders = sum(mtxRemaining, 2);
        cvMaximum = (cvEltOrders == max(cvEltOrders));

        % Use the element orders just found to extract the maximum elements into
        % the list of maximum sets (among those remaining) and append them to the
        % list of maximal sets.  Also, remove the newly-found maximal sets from the
        % list of remaining sets to search.
        mtxMaximumRemaining = mtxRemaining(cvMaximum, :);
        mtxMaximal = [mtxMaximal; mtxMaximumRemaining];
        mtxRemaining(cvMaximum, :) = [];

        % Since these collections are stored as matrice of zeros and ones, the size
        % of the pairwise intersections of their sets can be computed by the
        % following multiplication.
        mtxNumEltsInCommon = mtxRemaining * mtxMaximumRemaining.';

        % If there is more than one entry in a row of the matrix we just found
        % whose value is the size of the set corresponding to that row, then the
        % corresponding set must not be maximal; remove these sets from
        % `mtxRemaining`.  This is the pruning step that will (I hope) save time.
        % And, yes, in my tests, computing an outer-product was actually
        % significantly faster than using `repmat` in creating `mtxEltOrders`.
        mtxEltOrders = sum(mtxRemaining, 2) * ones(1, size(mtxNumEltsInCommon, 2));
        mtxRemaining(sum(mtxNumEltsInCommon == mtxEltOrders, 2) > 1, :) = [];
    end

    % Return the maximal sets as a `Collection` object.
    cllnMaximal = Collection(mtxMaximal);




    % Keep the old code for reference (in case the above algorithm is slower).
    % 
    % % Since this collection is stored as a matrix of zeros and ones, the size
    % % of the pairwise intersections of its sets can be computed by the
    % % following multiplication.
    % mtxNumEltsInCommon = this.Sets * this.Sets.';
    % 
    % % If there is exactly one entry in a row  of the matrix we just found whose
    % % value is the size of the set corresponding to that row, then the
    % % corresponding set must be maximal; otherwise, the corresponding set is
    % % not maximal.  Yes, in my tests, computing an outer-product was actually
    % % faster than using `repmat`.
    % tmp = diag(mtxNumEltsInCommon) * ones(1, this.Size);
    % cvMaximalIndices = (sum(mtxNumEltsInCommon == tmp, 2) == 1);
    % 
    % % Extract the maximal sets from this collection.  This `subsref` notation
    % % has to be used since we do not want to call the built-in indexing method.
    % tmp = this.ToMatrix();
    % cllnMaximal = Collection(tmp(cvMaximalIndices, :));
    % % cllnMaximal = this.subsref(substruct('()', {cvMaximalIndices}));



    % Even older code (more memory efficient but slower).
    % 
    % disp(size(this.Sets));
    % 
    % % We will keep track of the indices of the generating elements that are
    % % facets.
    % cvMaximalEltIndices = false(this.Size, 1);
    % 
    % % Since the sets are stored as a matrix of zeros and ones, the size of the
    % % intersection sets the set elements can be computed by the following
    % % multiplication.
    % mtxEltsInCommon = this.Sets * this.Sets.';
    % 
    % % Loop through the elements of the generating set.
    % for ii = (1 : this.Size)
    %     % The size of the current set.
    %     iSetSize = mtxEltsInCommon(ii, ii);
    % 
    %     % If there is exactly one entry in row `ii` whose value is the size of the
    %     % current set, then this set must be maximal; otherwise, it is not.
    %     if (length(find(mtxEltsInCommon(ii, :) == iSetSize)) == 1)
    %         cvMaximalEltIndices(ii) = true;
    %     end
    % end
    % 
    % % Extract the facets from the generating set.
    % tmp = this.ToMatrix();
    % cllnMaximal = Collection(tmp(cvMaximalEltIndices, :));
end