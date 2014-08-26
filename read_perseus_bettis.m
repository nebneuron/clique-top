function [ bettis ] = read_perseus_bettis(fileName, maxFilt, maxDim, ...
    betti0 )

% ----------------------------------------------------------------
% READ PERSEUS BETTIS
% written by Chad Giusti, 6/2014
%
% Read the betti numbers output by Perseus into an integer array
%
% INPUT:
%   fileName: Name of the file to read, with complete path if not
%       the working directory
%   maxFilt: Maximum filtration level/frame from which to read 
%       simplices from. The function will read inputs in the 
%       range 1-maxFilt.
%   maxDim: The maximum Betti number to read
%   betti0: Boolean flag indicating whether to discard Betti 0.
%
% OUTPUT:
%   bettis: A maxFilt x maxDim array of integers whose (i,j)
%       entry is the number of cycles of dim j appearing 
%       in the ith filtration level. If betti0 is true, the array
%       is instead maxFilt x (maxDim+1) and cycles of dim j
%       are recorded in column j+1.
%
% ----------------------------------------------------------------


% ----------------------------------------------------------------
% Open the file and read the outputs into the array
% ----------------------------------------------------------------

try
    fid = fopen(fileName, 'r');

    fgets(fid);                 % first line will be blank

    tline = fgets(fid);         % get first line and extract number of
                                % columns
    numCols = sum(tline == ' ')-1;
    stringFormat = [];
    for i=1:numCols
        stringFormat = [stringFormat ' %u'];
    end
    
    fid = fopen(fileName, 'r'); % reset file position

    bettis = zeros(maxFilt,numCols - 1);

    thisInput = textscan(fid, stringFormat);

    for j = 2:numCols
        if length(thisInput{j}) == length(thisInput{1})
            bettis(thisInput{1}, j-1) = thisInput{j};
        end
    end
    
    fclose(fid);
    
catch exception
    disp(exception)
    throw(exception);
end

% ----------------------------------------------------------------
% Perseus does not output data for filtrations where nothing changes
% homologically. Fill these in in the matrix -- detect by checking
% that betti 0 is zero.
% ----------------------------------------------------------------

for i=2:maxFilt
    if (bettis(i,1) == 0)
        bettis(i,:) = bettis(i-1,:);
    end
end

% ----------------------------------------------------------------
% Drop the Betti 0 information if indicated.
% ----------------------------------------------------------------

if betti0
    bettis = bettis(:,1:maxDim+1);
else
    bettis = bettis(:,2:maxDim+1);
end

end

