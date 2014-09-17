classdef LinearCode < Code
    % Description:
    %    <None>
    % Properties:
    %    <None>
    % Methods
    %    <methods inherited from `Code`>
    %    GeneratorMatrix
    % Static Methods:
    %    GenerateWords
    %    GolayMatrix
    %    HammingMatrix
    %    ReedMullerMatrix
    
    properties (Access = protected)
        GenMtx
    end
    
    methods (Access = public)
        function code = LinearCode(mtxGenerator, bIsFullRank)
            %---------------------------------------------------------------------------
            % Usage:
            %    code = LinearCode(mtxGenerator)
            % Description:
            %    Construct a binary code from the provided generator matrix.
            % Arguments:
            %    mtxGenerator
            %       The generator matrix of this code; the resultant code is the row
            %       span of this matrix.
            %    bIsFullRank (default: `false`)
            %       If this is `true`, then the generator matrix is assumed to be
            %       full-rank and no checking is done to ensure that all codewords
            %       are distinct; if it is `false`, all resultant codewords are
            %       guaranteed to be distinct. 
            %---------------------------------------------------------------------------
            
            if nargin < 2
                bIsFullRank = false;
            end
            
            cllnWords = LinearCode.GenerateWords(mtxGenerator, bIsFullRank);
            code = code@Code(cllnWords);
            code.GenMtx = mtxGenerator;
        end
    end
    
    methods (Access = public)
        mtxAdj = GeneratorMatrix(this)
    end
    
    methods (Static, Access = public)
        cllnWords = GenerateWords(mtxGenerator, bIsFullRank)
        
        mtxGen = GolayMatrix()
        
        mtxGen = HammingMatrix(r)
        
        mtxGen = ReedMullerMatrix(m, r)
    end
end