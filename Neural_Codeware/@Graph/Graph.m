classdef Graph < handle
    % Description:
    %    <None>
    % Properties:
    %    <None>
    % Methods:
    %    CliqueComplex
    %    Complement
    %    CountCliques
    %    display
    %    GetCliques
    %    HellyCompletion
    %    Plot
    %    Save
    %    Size
    %    ToMatrix
    % Static Methods:
    %    Random
    %    DropCliques
    
    properties (GetAccess = protected, SetAccess = protected)
        AdjacencyMatrix
    end
    
    methods (Access = public)
        function this = Graph(mtxAdjacency)
            %--------------------------------------------------------------------------
            % Usage:
            %    obj = Graph(mtxAdjacency)
            % Description:
            %    Constructs a `Graph` object (representing an undirected graph).
            % Arguments:
            %    mtxAdjacency
            %       A (symmetric) matrix with non-zero entries indicating edges.  All
            %       non-zero entries are stored as `1`.
            %--------------------------------------------------------------------------
            
            if ~isequal(mtxAdjacency, mtxAdjacency.')
                warning('Custom:Class:Graph:constructor', ...
                    'Adjacency matrix is not symmetric.  Using upper-triangular portion.');
            end
            
            % Blindly convert to a symmetric matrix.
            mtxUpper = triu(mtxAdjacency, 1);
            this.AdjacencyMatrix = spones(mtxUpper + mtxUpper.');
        end
    end
    
    methods (Access = public)
        objComplex = CliqueComplex(this, iMaxCliqueSize)
        
        iNum = CountCliques(this, iMin, iMax, bMaximal)
        
        gphComp = Complement(this)
        
        display(this, iNumToDisplay)
        
        cllnCliques = GetCliques(this, iMin, iMax, bMaximal)
        
        Plot(this, mtxCoords)
        
        Save(this, strFile)
        
        [iVerts, iEdges] = Size(this)
        
        mtxAdj = ToMatrix(this)
    end
    
    methods (Static)
        gphRand = Random(iSize, fSparsity)
        
        gphRand = DropCliques(iSize, iCliqueSize, iNumCliques)
    end
end