% ----------------------------------------------------------------
% PREPROCESS DATA
%
% Perform standard preprocessing of data files before we begin analysis.
% This consists of 
%    - standardizing variable names from various data file formats,
%    - removing trials which do not fit path parameters in analysis 
%      runs which involve multiple trials,
%    - clipping spike trains to observe spikes which occur only within set
%      experiment begin/end times and renormalizing those spike times to 
%      begin at 1, and 
%    - removing spike trains which correspond to interneurons, are located 
%      outside the hippocampus or do not fire within acceptable average 
%      firing rate parameters.
%
% This script assumes that certain parameters have been set and
% the file loaded, as by SET CCG PARAMETERS AND LOAD DATA FILE.
% ----------------------------------------------------------------

disp('Standardizing data ');    
tic;

% ----------------------------------------------------------------
% Standardize variable names from various data file types.
% ----------------------------------------------------------------

switch Parameters.DataType 
    case {'SLEEP'}
        rawSpikeTimes = SpikeTimes;
        if isfield(Par,'IsInterneuron')
            isIntern = Par.IsInterneuron;          
        else 
            isIntern = zeros(size(rawSpikeTimes,1),1);
        end

    case {'CORTICAL'}
        
        if exist('Par','var')
            Parameters.SamplingFrequency = Par.SamplingFrequency;
        end
        if exist('SpkCnt','var')
            rawSpikeTimes = SpkCnt;
        else 
            rawSpikeTimes = SpikeTimes;
        end
        isIntern = zeros(size(rawSpikeTimes,1),1);
        
    case {'OPENFIELD'}       
        if exist('Data','var')
            rawSpikeTimes = Data.SpikeTimes;
        elseif exist('Spike', 'var')
            numCells = length(Clu.totClu);
            rawSpikeTimes = cell(numCells,1);
            for i=1:length(Spike.res)
                rawSpikeTimes{Spike.totclu(i)} = ...
                    [rawSpikeTimes{Spike.totclu(i)} Spike.res(i)];
            end
        else
            rawSpikeTimes = SpikeTimes;
        end
        
        if isfield(Par,'IsInterneuron')
            isIntern = Par.IsInterneuron;          
        elseif exist('Clu', 'var')
            isIntern = Clu.isIntern;
        else
            isIntern = zeros(size(rawSpikeTimes,1),1);
        end


    case {'WHEEL_SINGLE', 'HOMECAGE_SINGLE'}
        rawSpikeTimes = trials{Parameters.trialToUse}.Spikes;
        if exist('cluList_isIntern','var')
            isIntern = cluList_isIntern;
        else 
            isIntern = zeros(size(rawSpikeTimes,1),1);
        end

    case {'WHEEL_AVG', 'HOMECAGE_AVG', 'WHEEL_CONCAT', 'HOMECAGE_CONCAT'}
        rawTrials = cell(length(trials),1);
        for i=1:length(trials)
            rawTrials{i} = trials{i}.Spikes;
        end
        if exist('cluList_isIntern','var')
            isIntern = cluList_isIntern;
        else 
            isIntern = zeros(size(rawTrials{1},1),1);
        end
        
    case {'NEW_WHEEL'}
        rawSpikeTimes = cell(max(unique(Spike.totclu)),1);
        for i=1:length(rawSpikeTimes)
            rawSpikeTimes{i} = [];
        end
        for i=1:length(Spike.res)
            yCoord = Track.yPix(Spike.res(i));
            if ((yCoord > 225) || (yCoord < 200))
                rawSpikeTimes{Spike.totclu(i)} = ...
                    [rawSpikeTimes{Spike.totclu(i)} Spike.res(i)];
            end            
        end
        isIntern = Clu.isIntern;
        
    otherwise
end

% ----------------------------------------------------------------
% Check for file-provided sampling frequency to override default
% ----------------------------------------------------------------

if exist('Par', 'var')
    if isfield(Par, 'SamplingFrequency')
        Parameters.SamplingFrequency = Par.SamplingFrequency;
        disp(sprintf('Using file-provided sampling frequency of %i',...
            Par.SamplingFrequency));
    end
end

% ----------------------------------------------------------------
% For sleep data, pare down to particular range specified by
% the particular dataset, as set in the parameters
% ----------------------------------------------------------------

if (strcmp(Parameters.DataType, 'SLEEP'))
    
    maxSpikeTime = 0;
    for i=1:length(rawSpikeTimes)
        if not(isempty(rawSpikeTimes{i}))
            maxSpikeTime = max(maxSpikeTime, max(rawSpikeTimes{i}));
        end
    end
        
    startBin = max(Parameters.SleepStartTime * ...
        Parameters.SamplingFrequency,1);
    endBin = min(Parameters.SleepEndTime * Parameters.SamplingFrequency,...
        maxSpikeTime);
    for i=1:length(rawSpikeTimes)
        rawSpikeTimes{i} = rawSpikeTimes{i}(find((rawSpikeTimes{i} > ...
            startBin) & (rawSpikeTimes{i} < endBin)));
    end
    effectiveExperimentLength = endBin - startBin;
end

% ----------------------------------------------------------------
% Discard wheel trials which do not follow L/R or R/L path
% as indicated in parameters.
%
% Commented, as we are no longer using L/R or R/L as a 
% distinguishing feature for wheel trials
% ----------------------------------------------------------------

% if (strcmp(Parameters.DataType, 'WHEEL_AVG') || ...
%      strcmp(Parameters.DataType, 'WHEEL_CONCAT')) 
%   validTrials = zeros(length(trials),1);
%   for i=1:length(trials)
%       validTrials(i) = (strcmp(trials{i}.pastLR,Parameters.pastLR) && ...
%             strcmp(trials{i}.futureLR,Parameters.futureLR));
%   end           
%   rawTrials = rawTrials(logical(validTrials));
% end

% ----------------------------------------------------------------
% When working with multiple trials, concatenate into one
% long 'trial' for CCG purposes.
% ----------------------------------------------------------------

if (strcmp(Parameters.DataType, 'WHEEL_CONCAT') || ...
        strcmp(Parameters.DataType, 'HOMECAGE_CONCAT')) 
                                                        
    rawSpikeTimes = cell(length(rawTrials{1}),1);       
    thisOffset = 0;
    for i=1:length(rawTrials)                      
        nextOffset = 0;
        for j = 1:length(rawTrials{1})           
             shiftedTrial = rawTrials{i}{j} + thisOffset;

             if (not(isempty(shiftedTrial)))
                nextOffset = max(nextOffset, max(shiftedTrial));
             end
             
             rawSpikeTimes{j} = [rawSpikeTimes{j}; shiftedTrial];
         end
        thisOffset = nextOffset + 3 * Parameters.CCGWindowWidth * ...
                        Parameters.SamplingFrequency;
    end

end    

% ----------------------------------------------------------------
% Normalize spike times so experiment begins at bin 1.
% ----------------------------------------------------------------


disp('Normalizing spike times.');
tic;
firstSpike = realmax;
lastSpike = 0;
for i=1:length(rawSpikeTimes) 
    if not(isempty(rawSpikeTimes{i}))
        firstSpike=min(firstSpike,min(rawSpikeTimes{i}));
    end
end

normedSpikeTimes = cell(length(rawSpikeTimes),1);
for i=1:length(rawSpikeTimes) 
    normedSpikeTimes{i} = floor(rawSpikeTimes{i} - firstSpike + 1);
    if not(isempty(normedSpikeTimes{i}))
      lastSpike=max(lastSpike,max(normedSpikeTimes{i}));
   end
end

toc;


% ----------------------------------------------------------------
% Remove flagged interneurons, cells with low activity levels and
% Entorhinal Cortex cells from sample
% ----------------------------------------------------------------

disp('Computing cell firing rates and removing low activity cells.');
tic; 

if (exist('Par', 'var')) && (isfield(Par,'cell_location'))
        % remove EC cells from the sample (and the interneuron list to
        % maintain indices)

    cellsInHippocampus = cellfun(@(x) ...
       not(strcmp(x,'EC')),Par.cell_location);
   normedSpikeTimes = normedSpikeTimes(cellsInHippocampus);
   isIntern = isIntern(cellsInHippocampus);
end
    
normedSpikeTimes = normedSpikeTimes(not(logical(isIntern)));
        % remove interneurons from the sample


% ----------------------------------------------------------------
% Compute average firing rates of cells, compensating for
% concatenation or removal of track sections if this occurred.
% ----------------------------------------------------------------
        
effectiveExperimentLength = floor(lastSpike);        
if (strcmp(Parameters.DataType, 'WHEEL_CONCAT') || ...
        strcmp(Parameters.DataType, 'HOMECAGE_CONCAT')) 
        % if we concatenated trials, discount buffer when computing average
        % firing rate
    
    effectiveExperimentLength = effectiveExperimentLength - ...
        3 * Parameters.CCGWindowWidth * Parameters.SamplingFrequency * ...
        (length(rawTrials) - 1);
end

if (strcmp(Parameters.DataType, 'NEW_WHEEL'))
    effectiveExperimentLength = effectiveExperimentLength - ...
        length(find((Track.yPix <= 225) & (Track.yPix >= 200)));
end

firingRates = zeros(length(normedSpikeTimes),1);
firingRateInRange = zeros(length(normedSpikeTimes),1);
for i=1:length(normedSpikeTimes) % compute average firing rate for cells
    firingRates(i) = (length(normedSpikeTimes{i}) / ...
        effectiveExperimentLength) * Parameters.SamplingFrequency;
    firingRateInRange(i) = (Parameters.MinFiringRate <= ...
        firingRates(i)) &&  (firingRates(i) <= Parameters.MaxFiringRate);
end

% ----------------------------------------------------------------
% Discard cells which lie outside the given firing rate range
% ----------------------------------------------------------------

normedSpikeTimes = normedSpikeTimes(logical(firingRateInRange));
firingRates = firingRates(logical(firingRateInRange));

% ----------------------------------------------------------------
% Count remaining cells.
% ----------------------------------------------------------------

numCells = size(normedSpikeTimes,1);

toc;
