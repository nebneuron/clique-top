classdef Code < handle
    % Description:
    %    <None>
    % Properties:
    %    Words
    %    Metric
    % Methods:
    %    CodeComplex
    %    Decode  
    %    DecodeMAP
    %    Distance
    %    Graph   
    %    CodewordGraph
    %    Length  
    %    RandomSample
    %    Rate    
    %    SetDistribution
    %    SetMetric
    %    Shuffle 
    %    Size    
    %    Sparsity
    %    ToMatrix
    % Static Methods
    %    NordstromRobinson
    %    Random   
    %    RandomConstantWeight
    %    ShiftCode
    
    properties (GetAccess = public, SetAccess = protected)
        Words
        Metric
    end
    
    properties (GetAccess = public, SetAccess = protected)
        Distribution
    end
    
    methods (Access = public)
        function this = Code(words, cvDistribution)
            %---------------------------------------------------------------
            % Usage:
            %    code = Code(words, cvDistribution)
            % Description:
            %    Create a code binary code.
            % Arguments:
            %    mtxSets
            %       A matrix whose rows are indicator vectors of sets.  If
            %       entry (i, j) is nonzero, then set i contains vertex j.
            %    cellSets
            %       A 1-dimensional cell array with each entry being a vector
            %       containing a subset of some superset.
            %    n
            %       The size of the superset of the elements of this collection.
            % Note:
            %    No checking is done to ensure that specified elements are distinct;
            %    hence, the resulting object is allowed to contain duplicate
            %    sets.
            %---------------------------------------------------------------
            
            if isa(words, 'Collection')
                mtxWords = unique(ToMatrix(words), 'rows');
                this.Words = Collection(mtxWords);
            else
                this.Words = Collection(words);
            end
            
            if nargin < 2
                cvDistribution = ones(Size(this), 1);
            end
            
            this.Metric = Code.HammingDist;
            this.SetDistribution(cvDistribution);
        end
    end
    
    methods (Access = public)
        clln = CodeComplex(this)
        
        cllnDecoded = Decode(this, clln)
        
        cllnDecoded = DecodeMAP(this, clln)
        
        d = Distance(this, x, y)
        
        gph = Graph(this)
        
        gph = CodewordGraph(this, tol)
        
        iLength = Length(this)
        
        cllnRand = RandomSample(this, iSize)
        
        r = Rate(this)
        
        SetDistribution(this, cvDistribution)
        
        SetMetric(this, fcnHandle)
        
        codeNew = Shuffle(this)
        
        iSize = Size(this)
        
        s = Sparsity(this)
        
        mtx = ToMatrix(this)
    end
    
    properties (Constant)
        HammingDist = @(u, v) nnz(xor(u, v));
        
        AsymmetricDist = @(u, v) max(nnz(and(u, 1 - v)), ...
                                     nnz(and(1 - u, v)));
    end
    
    methods (Static)
        obj = NordstromRobinson()
        
        obj = Random(iLength, iNumWords, fSparsity)
        
        obj = RandomConstantWeight(iLength, iNumWords, iWeight)
        
        obj = ShiftCode(n, k)
    end
end