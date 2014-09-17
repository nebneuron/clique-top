function d = Distance(this, x, y)
    %---------------------------------------------------------------------------
    % Usage:
    %    d = this.Distance(x, y)
    % Description:
    %    Find the distance between the given vectors using the code's
    %    internal metric.
    %---------------------------------------------------------------------------
    
    assert(isvector(x) && isvector(y), ...
           'Arguments 2 and 3 must both be vectors.');
    
    d = this.Metric(x, y);
end