function [ maxFiltration ] = combine_cliques_and_write_to_file(...
    symMatrix, maxCliqueSize, maxDensity, filePrefix, writeMaxCliques )

% ----------------------------------------------------------------
% ENUMERATE CLIQUES AND WRITE TO FILE
% written by Chad Giusti, 9/2014
%
% Given a symmetric matrix, use an iterative "combining" method to
% enumerate cliques of a fixed size or smaller in the thresholded family 
% of graphs with adjancency matrices obtained through thresholding the
% matrix at successively lower values until the density of above threshold 
% entries is above a specified maximum density. Write these cliques along
% with the threshold level to a file for input to Perseus.
% 
% ** THE INPUT MATRIX IS CURRENTLY ASSUMED TO HAVE NO REPEATED ENTRIES**
%
% INPUTS:
%	symMatrix: the symmetric matrix whose order complex
%       we are working with 
%   maxCliqueSize: maximum size of clique to enumerate
%   maxDensity: maximum edge density -- stopping condition
%   filePrefix: file prefix for output file
%
% ----------------------------------------------------------------

numVertices = size(symMatrix, 1);

% ----------------------------------------------------------------
% Get a list of the off-diagonal entries of the matrix.
% ----------------------------------------------------------------

offDiagMask = logical(triu(ones(numVertices),1));
offDiagEntries = sort(unique(symMatrix(offDiagMask)), 'descend');

% ----------------------------------------------------------------
% Ensure that the off-diagonal matrix entries are all positive
% except the smallest one, which doesn't matter anyway
% ----------------------------------------------------------------

minEntry = min(offDiagEntries);

shiftedSymMatrix = symMatrix - ...
    minEntry * (ones(numVertices) - eye(numVertices));
shiftedOffDiagEntries = offDiagEntries - ...
    minEntry * ones(size(offDiagEntries));

% ----------------------------------------------------------------
% Whenever an entire row of entries in the matrix (off the diagonal)
% is above threshold, there can be no further homology. Stop there
% at the latest!
% ----------------------------------------------------------------

specifiedMaxFiltration = floor(nchoosek(numVertices, 2) * maxDensity);

maxMinColEntry = max(min(shiftedSymMatrix +...
                    eye(numVertices) * max(shiftedOffDiagEntries)));
computedMaxFiltration = find(shiftedOffDiagEntries == maxMinColEntry);

maxFiltration = min(specifiedMaxFiltration, computedMaxFiltration);

% ----------------------------------------------------------------
% Construct an ordered list of edges to add to the matrix based
% on decresing entry size
% ----------------------------------------------------------------

edgeList = zeros(maxFiltration, 2);

for f = 1:maxFiltration
    [edgeList(f,1), edgeList(f,2)] = ...
        find(shiftedSymMatrix == shiftedOffDiagEntries(f), 1, 'first');
end

% ----------------------------------------------------------------
% Create the output file and add the first line indicating
% clique notation format (see Perseus documentation)
% ----------------------------------------------------------------

cliqueFid = fopen(sprintf('%s_simplices.txt',filePrefix), 'w');
fprintf(cliqueFid, '1\n');  

if writeMaxCliques
    maxCliqueFid = fopen(sprintf('%s_max_simplices.txt',filePrefix), 'w');
    fprintf(maxCliqueFid, '1\n');  
end

% ----------------------------------------------------------------
% Initialize clique list to the set of vertices in the graph
% and output them to the file.
% ----------------------------------------------------------------

cliqueMatrix = sparse(eye(numVertices));

nonemptyIntersections = sparse(false(numVertices));

print_clique_matrix_to_perseus_file(cliqueMatrix, maxCliqueSize, [], cliqueFid, 1);

% ----------------------------------------------------------------
% At each filtration level, create a list of newly added cliques
% in the size range (2, maxCliqueSize) and output them to file
% ----------------------------------------------------------------

for f = 1:maxFiltration
       
    % ----------------------------------------------------------------
    % Get a list of maximal cliques containing each vertex in the new 
    % edge, and compute which pairs from these lists intersect,
    % thus forming new cliques at this filtration 
    % ----------------------------------------------------------------

    cliqueIndices = [cliqueMatrix(:,edgeList(f,1)) ...
                     cliqueMatrix(:,edgeList(f,2))];
       
    possibleIntersections = sparse(logical(cliqueIndices(:, 1) ...
        * cliqueIndices(:, 2)'));
    actualIntersections = nonemptyIntersections & possibleIntersections;
    [ints_1, ints_2] = find(actualIntersections);
        
    % ----------------------------------------------------------------
    % Some current maximal cliques will be contained in new maximal
    % ----------------------------------------------------------------
    
    remIndex = 0;
    cliquesToRemove = zeros(2 * (length(ints_1)+1),1);
    
    if ~isempty(ints_1)
        % ---------------------------------------------------------------- 
        % The two vertices lie in existing cliques which intersect one
        % another. Get a list of unique intersections of cliques containing
        % the two vertices.
        % ----------------------------------------------------------------
        
         [cliqueInts, ia, ~] = unique(cliqueMatrix(ints_1, :) & ...
                cliqueMatrix(ints_2, :), 'rows');            
         ints_1 = ints_1(ia);
         ints_2 = ints_2(ia);

         numIntersections = length(ints_1);
         
         if numIntersections > 1
            % ------------------------------------------------------------
            % It is possible that some of these new intersections are not
            % maximal under containment. Detect this and remove smaller 
            % elements
            %
            % To do this quickly in matlab, we vector-ize the computation.
            % Observe that if one of the intersection sets is properly 
            % contained in another then the intersection of those 
            % sets equals the smaller of the two. Since we have a binary
            % set membership matrices, we can find intersection size using
            % matrix product. The diagonal elements are the sizes of the 
            % underlying sets, from which we construct comparison matrices
            % to do the inequality comparison across the whole matrix
            % at once. Lastly, we check which of the "complete" overlaps 
            % are with larger sets and remove those sets.
            % ------------------------------------------------------------

            nCliqueInts = double(cliqueInts);
         
            cliqueIntOverlaps = nCliqueInts * nCliqueInts';      
            cliqueIntSizes = ...
                cliqueIntOverlaps(logical(eye(numIntersections)));            
            sizeCompArray = (cliqueIntSizes * ones(1, numIntersections))';
            fullOverlap = (sizeCompArray == cliqueIntOverlaps);
            fullOverlap(logical(eye(numIntersections))) = 0;
            
            isMaximal = ...
                ~any((fullOverlap .* sizeCompArray') > sizeCompArray,1);                                    

            cliqueInts = cliqueInts(isMaximal, :);
            ints_1 = ints_1(isMaximal);
            ints_2 = ints_2(isMaximal);

         end
                      
        % ----------------------------------------------------------------
        % Build the sparse matrix representation of the new cliques
        % and add their intersection information to the matrix
        % ----------------------------------------------------------------

         addedRows = length(ints_1);
         numNewEntries = nnz(cliqueInts) + 2 * addedRows;

         cliqueColsToAdd = zeros(numNewEntries, 1);
         cliqueRowsToAdd = ones(numNewEntries, 1);

         maxNumIntersections = max(sum(nonemptyIntersections));

         neiOldCliqueColsToAdd = zeros(addedRows * maxNumIntersections, 1);
         neiOldCliqueRowsToAdd = ones(addedRows * maxNumIntersections, 1);         
                  
         addIndex = 0;
         remIndex = 0;
         neiOldIndex = 0;
         
         for i=1:addedRows

            % ------------------------------------------------------------
            % For each clique to add, build new sparse matrix rows
            % ------------------------------------------------------------
             
            intersectionSize = nnz(cliqueInts(i,:));
            cliqueColsToAdd(addIndex+1:addIndex+intersectionSize) = ...
                find(cliqueInts(i,:));
            cliqueColsToAdd((1:2)+addIndex+intersectionSize) = ...
                edgeList(f,:);
            cliqueRowsToAdd(addIndex+1:addIndex+intersectionSize + 2) = ...
                ones(intersectionSize + 2, 1) * i;
            addIndex = addIndex + intersectionSize + 2;             
                        

            % ------------------------------------------------------------
            % Determine which cliques in the graph this new clique
            % intersects and record that information for new rows
            % in the intersection sparse matrix
            % ------------------------------------------------------------
            
            newVerticesInClique = sparse(ones(2,1), edgeList(f,:),...
                ones(2,1), 1, numVertices);
            newClique = cliqueInts(i,:) | newVerticesInClique;
            
            intersectionVector = nonemptyIntersections(:,ints_1(i)) |...
                nonemptyIntersections(:,ints_2(i));
            intersectionCliques = find(intersectionVector);
            possibleOldInts = cliqueMatrix(intersectionVector, :);
            actualOldInts = find(any(possibleOldInts(:, newClique),2));
            
            numOldInts = length(actualOldInts);
            neiOldRange = neiOldIndex+1:neiOldIndex+numOldInts;
            neiOldCliqueColsToAdd(neiOldRange)= ...
                intersectionCliques(actualOldInts);
            neiOldCliqueRowsToAdd(neiOldRange) = i;            
            neiOldIndex = neiOldIndex + numOldInts;
                                   
            % ------------------------------------------------------------
            % For each clique to add, build new sparse matrix rows
            % ------------------------------------------------------------
            
            if (intersectionSize == nnz(cliqueMatrix(ints_1(i),:)) - 1)
                remIndex = remIndex + 1;
                cliquesToRemove(remIndex) = ints_1(i);
            end

            if (intersectionSize == nnz(cliqueMatrix(ints_2(i),:)) - 1)
                remIndex = remIndex + 1;
                cliquesToRemove(remIndex) = ints_2(i);
            end
            
         end         
         
         neiOldCliqueColsToAdd = neiOldCliqueColsToAdd(1:neiOldIndex);
         neiOldCliqueRowsToAdd = neiOldCliqueRowsToAdd(1:neiOldIndex);                  
         
    else
        % ----------------------------------------------------------------
        % These two vertices share no cliques at all, so insert the edge
        % remove either vertex from the clique list if they are still 
        % singletons, and update the intersection matrix
        % ----------------------------------------------------------------
         
         addedRows = 1;
         addIndex = 2;
         cliqueColsToAdd = edgeList(f, :);
         cliqueRowsToAdd = ones(2,1);
        
         neiOldCliqueColsToAdd = find(cliqueIndices(:,1) + cliqueIndices(:,2));
         neiOldCliqueRowsToAdd = ones(nnz(neiOldCliqueColsToAdd),1);        
                     
        % ----------------------------------------------------------------
        % Check to see if each vertex is listed as a maximal clique
        % and mark it for removal if so
        % ----------------------------------------------------------------

         for i=1:2
             [isRow, rowNum] = ismember(sparse(1, edgeList(f,i), ...
                 1, 1, numVertices), cliqueMatrix, 'rows');
 
             if isRow
                 remIndex = remIndex + 1;
                 cliquesToRemove(remIndex) = rowNum;
             end
         end        
               
    end
        
   % ----------------------------------------------------------------
   % Update the clique matrix by adding rows and removing cliques
   % that are contained in new maximal cliques
   % ----------------------------------------------------------------
    numOldCliques = size(cliqueMatrix,1);
    
    cliquesToRemove = cliquesToRemove(1:remIndex);
    cliquesToKeep = setdiff(1:numOldCliques, cliquesToRemove);
    addedCliques = sparse(cliqueRowsToAdd(1:addIndex), ...
        cliqueColsToAdd(1:addIndex), ones(addIndex,1), addedRows, ...
        numVertices);
    cliqueMatrix = [cliqueMatrix(cliquesToKeep,:); ...
        addedCliques];
    
   % ----------------------------------------------------------------
   % List intersections of new cliques with old ones
   % ----------------------------------------------------------------
    oldNewIntersections = sparse(neiOldCliqueRowsToAdd,...
        neiOldCliqueColsToAdd, ones(nnz(neiOldCliqueColsToAdd),1), ...
        addedRows, size(nonemptyIntersections,1));

   % ----------------------------------------------------------------
   % All the new cliques added intersect one another because they
   % share at least a common edge
   % ----------------------------------------------------------------
    newIntersections = sparse(ones(addedRows) - eye(addedRows));
        
    exCliquesToKeep = [cliquesToKeep (numOldCliques+1):(numOldCliques+addedRows)];

   % ----------------------------------------------------------------
   % Update the matrix of clique intersections
   % ----------------------------------------------------------------
    nonemptyIntersections = [nonemptyIntersections oldNewIntersections';...
        oldNewIntersections newIntersections];
    nonemptyIntersections = nonemptyIntersections(exCliquesToKeep,...
        exCliquesToKeep);
        
   % ----------------------------------------------------------------
   % Print the new maximal cliques at this filtraiton level to file
   % ----------------------------------------------------------------
    print_clique_matrix_to_perseus_file(addedCliques, maxCliqueSize,...
        edgeList(f,:), cliqueFid, f);
    
    if writeMaxCliques
        print_clique_matrix_to_perseus_file(addedCliques, -1,...
            edgeList(f,:), maxCliqueFid, f);
    end
        
end

fclose(cliqueFid);

if writeMaxCliques
    fclose(maxCliqueFid);
end

end