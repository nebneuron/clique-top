function FindWeights(this)
    %---------------------------------------------------------------------------
    % Usage:
    %    this.FindWeights()
    % Description:
    %    Compute and store (internally) the weights associated to the words
    %    in the stream complex.
    %---------------------------------------------------------------------------
    
    this.Complex = ...
        CodeComplex(this.Codes{StreamLength(this)});

    mtxFaces = ToMatrix(GetFaces(this.Complex));
    cvNumVerts = sum(mtxFaces, 2);
    cvWeights = StreamLength(this) * ones(size(mtxFaces, 1), 1);

    % A lot of extra computation is done here.  Can we remove the
    % extra computation at low expense (in a natural matlab-ish
    % way)?  How much time is this extra computation costing us?
    for i = (StreamLength(this) - 1 : -1 : 1)
        mtxWords = ToMatrix(this.Codes{i}.Words);
        cvWeights(max(mtxFaces * mtxWords', [], 2) == cvNumVerts) ...
            = i;
    end

    SetWeights(this.Complex, cvWeights);
end