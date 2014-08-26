function i = StreamLength(this)
    %---------------------------------------------------------------------------
    % Usage:
    %    i = this.StreamLength()
    % Description:
    %     Return the length of this code stream, i.e., the number of codes
    %     that this stream contains.
    %---------------------------------------------------------------------------
    
    i = length(this.Codes);
end