function SetMetric(this, fcnHandle)
    %---------------------------------------------------------------------------
    % Usage:
    %    this.SetMetric(fcnHandle)
    % Description:
    %    Set the internal metric on the codewords of this code.
    % Arguments:
    %    fcnHandle
    %        A handle to a function that accepts two row vectors as its input
    %        and outputs a single nonnegative scalar.
    %---------------------------------------------------------------------------
    
    this.Metric = fcnHandle;
end