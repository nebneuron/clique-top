function [ matrixLaplacian ] = weighted_matrix_laplacian( inputMatrix )

% ----------------------------------------------------------------
% WEIGHTED MATRIX LAPLACIAN
%
% The matrix Laplacian for a weighted matrix A with zeros along the
% diagonal is defined to be the Laplacian of the corresponding weighted 
% graph: L = D - A, where D is a diagonal matrix whose entries are the 
% row sums of A.
%
% INPUT: 
%   inputMatrix: the adjacency matrix for a weighted simple graph
%  
% OUTPUT: 
%   matrixLaplacian: the matrix Laplacian for inputMatrix
% ----------------------------------------------------------------


matrixLaplacian = -inputMatrix;
for i=1:size(inputMatrix,1)
    matrixLaplacian(i,i) = sum(inputMatrix(i,:));
end

end

