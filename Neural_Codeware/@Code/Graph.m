function gph = Graph(this)
    %---------------------------------------------------------------------------
    % Usage:
    %    gph = this.Graph()
    % Description:
    %    Retrieve the "cofire" graph of this code's collection of
    %    codewords.
    %---------------------------------------------------------------------------
    
    gph = Graph(this.Words);
end