function i = CodeLength(this)
    %---------------------------------------------------------------------------
    % Usage:
    %    n = this.CodeLength()
    % Description:
    %    Return the length of the codes in this stream.
    %---------------------------------------------------------------------------
    
    if length(this.Codes) > 0
        i = Length(this.Codes{1});
    else
        i = 0;
    end
end