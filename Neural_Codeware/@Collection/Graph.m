function gphOut = Graph(this)
    %------------------------------------------------------------
    % Usage:
    %    gphOut = clln.Graph()
    % Description:
    %    Retrieve the "cofire" graph of this collection.
    %------------------------------------------------------------
    
    mtx = ToMatrix(this);
    gphOut = Graph(mtx' * mtx > 0);
end