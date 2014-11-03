function [ maxFiltration ] = naive_enumerate_cliques_and_write_to_file( ...
    symMatrix, maxCliqueSize, maxDensity, filePrefix )

% ----------------------------------------------------------------
% NAIVE ENUMERATE CLIQUES AND WRITE TO FILE
% written by Chad Giusti, 11/2014
%
% Given a symmetric matrix, naively list all cliques of size under 
% the specified limit, along with the filtration level at which that
% clique is complete.
% 
% INPUTS:
%	symMatrix: the symmetric matrix whose order complex
%       we are working with 
%   maxCliqueSize: maximum size of clique to enumerate
%   maxDensity: maximum edge density -- stopping condition
%   filePrefix: file prefix for output file
%
% ----------------------------------------------------------------

matrixSize = size(symMatrix, 1);

maxFiltration = ceil(nchoosek(matrixSize,2) * maxDensity);

% ----------------------------------------------------------------
% Put matrix in order canonical form and set entries which lie
% beyond the density threhold to Inf
% ----------------------------------------------------------------

orderCanonicalForm = zeros(matrixSize);
orderedElements = sort(unique(symMatrix(:)), 'descend');
for i=1:matrixSize
    for j=i+1:matrixSize
        orderCanonicalForm(i,j) = ...
            find(orderedElements == symMatrix(i,j), 1, 'first');
        if orderCanonicalForm(i,j) > maxFiltration
            orderCanonicalForm(i,j) = Inf;
        end
    end
end
orderCanonicalForm = orderCanonicalForm + orderCanonicalForm';

% ----------------------------------------------------------------
% Create simplex output file and list vertices
% ----------------------------------------------------------------


cliqueFid = fopen(sprintf('%s_simplices.txt',filePrefix), 'w');
fprintf(cliqueFid, '1\n');    

for i=1:matrixSize
    fprintf(cliqueFid, '%i ', [0 i 1]);
    fprintf(cliqueFid, '\n');
end

% ----------------------------------------------------------------
% In order of increasing simplex size, list all simplices that 
% appear in the order complex (before the given max density)
% and print them to the file
% ----------------------------------------------------------------

for simplexSize = 2:maxCliqueSize
    
    index = 1:simplexSize;
    final = (matrixSize-simplexSize+1):matrixSize;
    
    complete = false;
    while ~complete
        % ----------------------------------------------------------------
        % Starting with the clique 1..simplexSize, take minors of the
        % order normal form and find the filtration when they appear.
        % ----------------------------------------------------------------
        
        thisMinor = orderCanonicalForm(index,index);
        
        thisFilt = max(max(thisMinor));
        if (thisFilt < Inf)
            % ------------------------------------------------------------
            % If no Inf appears, print this clique and the filtration in 
            % which is arisees to the file.
            % ------------------------------------------------------------

            fprintf(cliqueFid, '%i ', [simplexSize-1 index thisFilt]);
            fprintf(cliqueFid, '\n');
            incIndex = find(index < final, 1, 'last');
        else 
            % ------------------------------------------------------------
            % If an Inf appears, skip all minors that would include that 
            % same entry, since those cliques all appear after the density 
            % threshold
            % ------------------------------------------------------------
            
            [infrow, infcol] = find(thisMinor == Inf, 1, 'last');
            incIndex = min(max(infrow, infcol),...
                find(index < final, 1, 'last'));
        end
        
        % ----------------------------------------------------------------
        % Increment the minor indices and see if the process is complete
        % ----------------------------------------------------------------

        index(incIndex:end) = ...
            (index(incIndex)+1):(index(incIndex)+simplexSize-incIndex+1);
        
        if (index(1) > matrixSize - simplexSize)
            complete = true;
        end
    end         
end

fclose(cliqueFid);

end

