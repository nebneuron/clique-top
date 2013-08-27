function [ bettis ] = read_perseus_bettis(fileName, maxFilt, maxDim )

% ----------------------------------------------------------------
% READ PERSEUS BETTIS
%
% Read the betti numbers output by Perseus into an integer array
%
% INPUT:
%   fileName: Name of the file to read, with complete path if not
%       the working directory
%   maxFilt: Maximum filtration level/frame from which to read 
%       simplices from. The function will read inputs in the 
%       range 1-maxFilt.
%   maxDim: The maximum homological dimension of cycles to read
%
% OUTPUT:
%   bettis: A maxFilt x maxDim+1 array of integers whose (i,j)
%       entry is the number of cycles of dim (j-1) appearing 
%       in the ith filtration level.
% ----------------------------------------------------------------

bettis = zeros(maxFilt,maxDim+1);

% ----------------------------------------------------------------
% Initialize the input string to read the requested number of
% homological dimensions in the standard Perseus output format
% ----------------------------------------------------------------

stringFormat = ' Frame [%d]: ';
for i = 1:maxDim
    stringFormat = [stringFormat '%d '];
end
stringFormat = [stringFormat '%d'];

% ----------------------------------------------------------------
% Open the file and read the outputs into the array
% ----------------------------------------------------------------

try
    fid = fopen(fileName, 'r');

    tline = fgets(fid);
    while ischar(tline)
        if (length(tline) > 5) && (strcmp(tline(2:6),'Frame'))
            thisInput = textscan(tline, stringFormat);
            for j = 2:length(thisInput)
                if not(isempty(thisInput{j}))
                    if (thisInput{1} <= maxFilt)
                        bettis(thisInput{1}, j-1) = thisInput{j};
                    end
                end
            end
        end
    
        tline = fgets(fid);
    end
catch exception
    disp(exception)
    throw(exception);
end
end

