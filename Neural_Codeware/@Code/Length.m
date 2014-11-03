function l = Length(this)
    %---------------------------------------------------------------------------
    % Usage:
    %    l = this.Length()
    % Description:
    %    Retrieve the length of this code, i.e., the dimension of the ambient
    %    space that the code lives in.
    %---------------------------------------------------------------------------
    
    l = n(this.Words);
end