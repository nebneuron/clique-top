function [totalCCG, normalizedCCG] = ...
    maximal_ccg_to_total_asymmetric_normalized_ccg(maximalCCG, ...
    windowWidth, experimentLength, firingRates, samplingFrequency)

% ----------------------------------------------------------------
% MAXIMAL CCG TO TOTAL ASYMMETRIC NORMALIZED CCG
%
% This function takes as input a 3D CCG array, whose first index
% indicates the offset in the range [-tmax, tmax] and whose other
% indices indicate cell pairs, as well as other data about the 
% underlying point processes, then extracts a single
% cross-correlation coefficient, computed as the maximum of the
% integrals on [0, windowWidth] and [-windowWidth, 0] of the 
% CCGs, normalized with respect to product of firing rate and
% total widow time.
%
% INPUTS: 
%   maximalCCG: A 3D array whose (t, i, j) entry is the cross
%       correlation between the ith and jth processes when the
%       jth process is offset by time t. 
%       i.e. c_ij(t) = \sum p_i(\tau) * p_j(\tau + t)
%   windowWidth: The window width, in seconds, across which
%       to compute the total CCG 
%   experimentLength: How long, in time bins, the experiment ran.
%       Used to remove edge effect from sampling.
%   firingRates: An array containing the firing rates, in Hz, of 
%       each process. Used for normalizing. To remove, set these
%       to 1.
%   samplingFrequency: Sampling frequency in Hz. Number of bins
%       per second.
%
% OUTPUTS:
%   totalCCG: A matrix whose (i,j) entry is the maximum of the 
%       the integrals [0, windowWidth] and [-windowWidth,0] of
%       c_ij(t), normalized with respect to firing rate and
%       windowWidth.
%   normalizedCCG: The normalized version of the input matrix, 
%       maximalCCG.
%
% In the original context, individual matrix extries are the total
% cross-correlation (given by inner product) of the point 
% ith  and jth binary spike trains, offset by tau in [-tmax, tmax]
% ----------------------------------------------------------------

% ----------------------------------------------------------------
% Compute the size of the integration window.
% ----------------------------------------------------------------

numCorrCoeffs = size(maximalCCG,1);
numCells = size(maximalCCG,2);
binsInCCGWindow = windowWidth * samplingFrequency;

% ----------------------------------------------------------------
% Remove edge effect for finite sample length when normalizing
% by constructing array whose elements are the number of seconds 
% in the experiment minus those 'cut off' at the edge, then 
% normalize each CCG entry.
% ----------------------------------------------------------------

halfNumCorrCoeffs = floor(numCorrCoeffs/2);
timeWindowLengths = (ones(size(maximalCCG,1),1) * experimentLength -...
    [halfNumCorrCoeffs:-1:0 1:halfNumCorrCoeffs]')'/samplingFrequency;

normalizedCCG = zeros(size(maximalCCG));
for t=1:numCorrCoeffs
    for i=1:numCells
        for j=1:numCells
            normalizedCCG(t,i,j) = maximalCCG(t,i,j)/...
                (timeWindowLengths(t)*firingRates(i)*firingRates(j));
        end
    end
end

% ----------------------------------------------------------------
% Compute the total cross-correlation coefficient by summing 
% (integrating) correlation over the two windows and taking the 
% maximum. Ensure symmetry of the matrix by taking on the upper
% triangular half and symmetrizing.
% ----------------------------------------------------------------

tauNeg = sum(normalizedCCG((halfNumCorrCoeffs+1)-binsInCCGWindow:...
    (halfNumCorrCoeffs+1), :, :),1);
tauPos = sum(normalizedCCG((halfNumCorrCoeffs+1):...
    (halfNumCorrCoeffs+1)+binsInCCGWindow, :, :),1);

totalCCG = triu(max(tauNeg, tauPos),1);
totalCCG = totalCCG + totalCCG';
