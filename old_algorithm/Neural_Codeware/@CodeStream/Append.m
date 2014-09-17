function Append(this, codeNew)
    %---------------------------------------------------------------------------
    % Usage:
    %    this.Append(codeNew)
    % Description:
    %    Append a code to the calling stream.
    % Arguments:
    %    codeNew
    %        The code to append to the callind stream.
    %---------------------------------------------------------------------------
    
    assert(isa(codeNew, 'Code'), ...
           ['Attempted to add a non-`Code` object to a' ...
            ' `Codestream`.']);
    assert(( Length(codeNew) == CodeLength(this) ...
             || StreamLength(this) == 0), ...
           'Codes in a stream must have the same length.');

    this.Codes{StreamLength(this) + 1} = codeNew;
end