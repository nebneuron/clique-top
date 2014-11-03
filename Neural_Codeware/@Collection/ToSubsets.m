function cellSubsets = ToSubsets(this)
    %-----------------------------------------------------------------------
    % Usage:
    %    cellSubsets = obj.ToSubsets()
    % Description:
    %    Return a 1-dimensional cell array representation of this set.  Each
    %    entry is a vector containing the non-zero elements of a subset
    %    in this collection.
    %-----------------------------------------------------------------------
    
    cellSubsets = cell(Size(this), 1);
    
    for i = 1 : Size(this)
        cellSubsets{i} = find(this.Sets(i, :));
    end
end