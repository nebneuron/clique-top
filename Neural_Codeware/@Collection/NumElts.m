function iNum = NumElts(this)
    %-----------------------------------------------------------------------
    % Usage:
    %    iNum = NumElts(this)
    % Description:
    %    Return the number of elements in this set.  Same as method `Size`.
    %-----------------------------------------------------------------------
    
    iNum = size(this.Sets, 1);
end