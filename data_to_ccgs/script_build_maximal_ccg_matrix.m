% ----------------------------------------------------------------
% BUILD MAXIMAL CCG MATRIX
%
% Given (preprocessed) normed spike times from a data file, 
% compute a "maximal" CCG matrix across a large window from which 
% we will later extract CCGs on on shorter time scales as needed.
% Save this CCG and data about it in a standardized file format.
%
% Currently, we reject files if the number of cells is too low 
% to ensure the use only of robust datasets.
% 
% This script assumes that the data has been loaded and
% preprocessed using PREPROCESS DATA or an equivalent script.
% ----------------------------------------------------------------

matlabpool;
 
if (numCells > Parameters.cellThreshold)
    ccgMatrix = trains_to_ccg_matrix(normedSpikeTimes, ...
        Parameters.SamplingFrequency, Parameters.maxCCGWindowWidth);

    clear Par;
    Par.dataType = Parameters.DataType;
    Par.maxCCGWindowWidth = Parameters.maxCCGWindowWidth;
    Par.samplingFrequency = Parameters.SamplingFrequency;
    Par.completeOriginalDataFile = Parameters.InputFileName;
    Par.originalDataFileName = inFileName;
    Par.numCells = numCells;
    Par.effectiveExperimentLength = effectiveExperimentLength;
    Par.minFiringRate = Parameters.MinFiringRate;
    Par.maxFiringRate = Parameters.MaxFiringRate;

    save(sprintf('~/CCGs/%s_CCG.mat', inFileName), 'ccgMatrix', 'Par', ...
        'normedSpikeTimes', 'firingRates');

else 
    disp(sprintf('Skipped, numCells = %i',numCells));
end

matlabpool close;