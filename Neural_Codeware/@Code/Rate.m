function r = Rate(this)
    %---------------------------------------------------------------------------
    % Usage:
    %    r = this.Rate()
    % Description:
    %    Return the rate of the calling code.
    %---------------------------------------------------------------------------
    
    r = log2(Size(this)) / Length(this);
end