function [ distribution, infinite_intervals ] = ...
    read_persistence_interval_distribution(fileName, numFiltrations)

% ----------------------------------------------------------------
% READ PERSISTENCE INTERVAL DISTRIBUTION
% written by Chad Giusti, 6/2014
%
% Read the distribution of persistence interval lengths for a 
% particular homological dimension from Perseus output files.
%
% INPUT:
%   fileName: Name of the file to read, with complete path if not
%       the working directory
%
% OUTPUT:
%   distribution: An array containing a the distribution of interval
%       lengths. The final element is for "infinite" intervals with
%       no endpoint.
% ----------------------------------------------------------------

distribution = zeros(1, numFiltrations);

infinite_intervals = 0;

% ----------------------------------------------------------------
% Open the file and read the outputs into the array
% ----------------------------------------------------------------

if exist(fileName, 'file')

    try
        fid = fopen(fileName, 'r');

        tline = fgets(fid);
        while ischar(tline)
            interval = str2num(tline);
            if (interval(end) == -1)
                infinite_intervals = infinite_intervals + 1;
            else
                len = interval(end) - interval(1);
                distribution(len) = distribution(len)+1;
            end
            tline = fgets(fid);
        end
        fclose(fid);
    catch exception
        disp(exception.message);
        rethrow(exception);
    end
end

