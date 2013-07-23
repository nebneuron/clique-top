function [binaryTrains, endTime] = spike_times_to_binary_trains(trains)

% ----------------------------------------------------------------
% SPIKE TIMES TO BINARY TRAINS
%
% Convert a list of spike times given as a cell array of firing 
% times to a binary matrix whose non-zero entries correspond to 
% observed spikes.
%
% INPUT:
%   trains: Cell array whose elements correspond to neurons 
%       recorded in an experiment. The elements are vectors 
%       containing a list of  spike times (recorded in bin 
%       numbers) recorded for that neuron.
%
% OUTPUT: 
%   binaryTrains: A binary matrix whose rows correspond to 
%       neurons and columns correspond to time bins. An entry is 
%       1 if the corresponding neuron fired during that time bin.
%  endTime: the approximate total length of the experiment, 
%       measured by the last time a neuron fired
% ----------------------------------------------------------------


endTime = 0;
for i=1:length(trains)          % for each spike train
    if not(isempty(trains{i}))  % if activity was recorded
        endTime = max( endTime, trains{i}(end));
    end                         % check to see if a new 'last spike' 
end                             % appears

binaryTrains = zeros(length(trains),endTime);
for i=1:length(trains)          % for each train
    binaryTrains(i,round(trains{i}))=1 ;
end                             % record spikes in the matrix



