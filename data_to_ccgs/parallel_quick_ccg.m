function CCG = parallel_quick_ccg( binarySpikeTrains, halfBins )

% ----------------------------------------------------------------
% PARALLEL QUICK CCG
%
% Compute the pairwise CCG array of a family of spike trains. 
% Uses the matlab parallel processing pool to speed computations.
%
% Based on quick_ccg by Vladimir Itskov.
%
% NOTE: Runs much faster if the binarySpikeTrains matrix is 
% a sparse matrix. Be certain to pass it as a sparse matrix if
% possible.
%
% INPUT:
%   binarySpikeTrainsTranspose: Binary matrix whose rows are 
%       spike trains and whose columns are time bins. An element 
%       is 1 if the corresponding neuron fired in the 
%       corresponding time bin.
%   halfBins: A non-negative integer indicating the number of bins 
%       in the positive and negative direction of each bin to check 
%       for correlated spikes. 
%       
% Output:
%   CCG: A 3d array whose (t + HalfBins + 1, a, b) entry is the 
%       numberof pairs (S_a, S_b) such that S_a is an individual 
%       spike by cell a, S_b is  an individual spike by cell b, and 
%       the spike S_a occured t bins earlier than spike S_b
%       { in other words bin(S_b)-bin(S_a)=t}.
% ----------------------------------------------------------------

binarySpikeTrainsTranspose = binarySpikeTrains';

nCells = size(binarySpikeTrainsTranspose, 2);
RegCCG = zeros( halfBins+1, nCells, nCells );
OppCCG = zeros(halfBins, nCells, nCells );

parfor i=1:halfBins+1                 % for each time difference in bins
    shiftedDotProduct = full([zeros(halfBins+1-i,nCells); ...
        binarySpikeTrainsTranspose]' * [binarySpikeTrainsTranspose;...
        zeros(halfBins+1-i,nCells)]);
                                   % pad the spike train matrix with zeros
                                   % to shift the spikes by the appropriate
                                   % difference, then take the product
                                   % of these matrices to count
                                   % coincidences
    transposedDotProduct=shiftedDotProduct';
    RegCCG(i,:,:)=transposedDotProduct(:,:);              
    OppCCG(i,:,:) = shiftedDotProduct(:,:);
end

CCG = cat(1, RegCCG, OppCCG(halfBins:-1:1,:,:));

            % Fill in the CCG with the results.
            % Save time by noting that if (i, a, b)
            % is in the CCG, the same entry occurs
            % at (2 * halfBins + 2-i, b, a).

