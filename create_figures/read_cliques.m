function [ cliques ] = read_cliques(fileName, numFiltrations, numVertices )
% ----------------------------------------------------------------
% READ CLIQUES
%
% Read the maximal cliques in a filtered family of graphs as 
% output by Cliquer
%
% INPUT:
%   fileName: Name of the file to read, with complete path if not
%       the working directory
%   numFiltrations: Maximum filtration level/frame from which 
%       to read simplices from. The function will read inputs in 
%       the range 1-maxFilt.
%   numVertices: The maximum possible clique size
%
% OUTPUT:
%   cliques: A maxFilt x numVertices array of integers whose (i,j)
%       entry is the number of cliques of size j appearing 
%       in the ith filtration level.
% ----------------------------------------------------------------

cliques = zeros(numFiltrations,numVertices);

% ----------------------------------------------------------------
% Open the file and read the outputs into the array
% ----------------------------------------------------------------

try
    fid = fopen(fileName, 'r');
    tline = fgets(fid);  % throw away first line -- not a clique
    
    tline = fgets(fid);
    while ischar(tline)
        clique = str2num(tline);
        if (clique(end) <= numFiltrations)
            cliques(clique(end),length(clique)-1) = ...
                cliques(clique(end), length(clique)-1) + 1;   
        else
            break;
        end
        tline = fgets(fid);
    end
catch exception
    disp(exception)
    disp(exception.message);
end
end

