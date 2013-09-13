function [ shuffledMatrix ] = shuffle_symmetric_matrix_entries(...
    inputMatrix )

% ----------------------------------------------------------------
% SHUFFLE SYMMETRIC MATRIX ENTRIES
%
% Given a symmetric matrix with zeros on the diagonal, shuffle the 
% entries to produce a "random" symmetric matrix
%
% INPUT: 
%   inputMatrix: A symmetric matrix with zeros on the diagonal
%
% OUTPUT:
%   outputMatrix: A matrix produced by reordering the elements 
%       of inputMatrix using a permutation chosen uniformly from
%       those which permute (n choose 2) objects.
% ----------------------------------------------------------------


n = size(inputMatrix,1);
shuffledMatrix = zeros(n);

% ----------------------------------------------------------------
% Choose a random permutation on the upper triangular indicies
% and reorder the matrix using that permutation
% ----------------------------------------------------------------

upperTriangleIndices = find(triu(ones(n),1));
perm = randperm(length(upperTriangleIndices));
for i=1:length(perm)
    shuffledMatrix(upperTriangleIndices(perm(i))) = ...
        inputMatrix(upperTriangleIndices(i));
end
shuffledMatrix = shuffledMatrix + shuffledMatrix';

end

