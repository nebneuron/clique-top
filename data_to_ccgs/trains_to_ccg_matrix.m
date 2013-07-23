function [crossCorrelogram] = ...
    trains_to_ccg_matrix(trains, samplingFrequency, maxWindowWidth) 

% ----------------------------------------------------------------
% TRAINS TO CCG MATRIX
%
% INPUTS: 
%   trains: Cell arrays containing vectors whose entries are 
%       recorded firing times for that neuron during the trial.
%   samplingFrequency: Sampling frequency at which the data was 
%       gathered in Hz. Used to compute firing rates.
%   maxWindowWidth: Width of window across which to compute 
%       cross-correlograms of binary spike trains. Given in 
%       seconds.
%
% OUTPUTS: 
%   crossCorrelogram: cross correlogram for the family of neurons
%       computed at all offsets between -maxWindowWidth and 
%       maxWindowWidth (in seconds), given as a 3D array.
% ----------------------------------------------------------------


binaryTrains = spike_times_to_binary_trains(trains);
                    % convert the raw spike times to a binary array
                    % whose rows correspond to neurons and columns
                    % to time bins. An entry is 1 if the
                    % corresponding neuron fired during the time
                    % bin.                            

crossCorrelogram = parallel_quick_ccg( sparse(binaryTrains) ,...
    round(maxWindowWidth * samplingFrequency) );
                            

end                     







