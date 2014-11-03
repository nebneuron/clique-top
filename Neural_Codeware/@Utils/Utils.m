classdef Utils
    % Description:
    %    A class containing utility functions.
    % Static Methods: 
    %    BinaryVectors
    %    MatrixToSubsets
    %    PlotCircle
    %    SubsetsOf
    %    SubsetsOfSize
    %    SubsetsToMatrix
        
    methods (Static)
        mtxSubsets = SubsetsOf(vecIn)
        
        mtx = BinaryVectors(iLength)
        
        mtxSubsets = SubsetsOfSize(vecIn, iSize)
        
        celSubsets = MatrixToSubsets(mtxSubsets)
        
        mtxSubsets = SubsetsToMatrix(cellSubsets, iSetSize)
        
        plt = PlotCircle(center, r, iNumPts)
    end
end