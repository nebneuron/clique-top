% ----------------------------------------------------------------
% BUILD GEOMETRIC GRAPH CONTROLS
%
% Given a data CCG matrix, run a sequence of controls by building
% correlation matricies from the distance graphs of points
% dropped uniformly in various Euclidean spaces. Then, run 
% Cliquer and Perseus to compute the persistent homology of these
% controls.
%
% This script expects to receive as input several parameters in
% the struct 'Parameters', as produced by running SETUP 
% COMPUTATIONS.
% ----------------------------------------------------------------

% ----------------------------------------------------------------
% Based on the number of cells in the data set, choose a 
% collection of dimensions of Euclidean space into which to drop
% points for the control. This collection is currently always 
% d = {2, 4, 6, 8, 10, 15, 20, 25, 50, Parameters.numCells},
% under the assumption that Parameters.numCells > 50. Observe
% that this should be the largest "interesting" dimension, as 
% in any higher dimension the points will span a subspace of this
% dimension (generically).
% ----------------------------------------------------------------

numDimensions = 10;
dimensionList = [2 4 6 8 10 15 20 25 50 Parameters.numCells];

% ----------------------------------------------------------------
% Drop Parameters.numCells points uniformly in the Euclidean cube 
% for each choice of dimension, then construct from these matrices
% whose (i,j) entry is a decreasing function of the distance
% between the ith and jth points.
% ----------------------------------------------------------------

distanceGraphs = cell(numDimensions, Parameters.numControls);
for d=1:numDimensions
    for j=1:Parameters.numControls
        pos = rand(dimensionList(d), Parameters.numCells);
        distanceMatrix = dist(pos);

        weightedMatrix = sqrt(dimensionList(d)) - distanceMatrix;
                        % subtract distance matrix from max distance
                        % in unit cube

        distanceGraphs{d, j} = weighted_graph_to_p_thresholded_graphs(...
            weightedMatrix, pStep, maxP);
    end
end

% ----------------------------------------------------------------
% Drop Parameters.numCells points uniformly in the Euclidean cube 
% for each choice of dimension, then construct from these matrices
% whose (i,j) entry is a decreasing function of the distance
% between the ith and jth points.
% ----------------------------------------------------------------

distFid = cell(numDimensions, Parameters.numControls);
distMaxFid = cell(numDimensions, Parameters.numControls);
for d=1:numDimensions
    for j=1:Parameters.numControls
        distFid{d,j} = fopen(sprintf('dist_simplices_R%i_%i.s',...
            dimensionList(d), j), 'w');
        fprintf(distFid{d,j}, '1\n');    
    
        distMaxFid{d,j} = fopen(sprintf('dist_max_simplices_R%i_%i.s',...
            dimensionList(d),j), 'w');
        fprintf(distMaxFid{d,j}, '1\n');
    end
end

% ----------------------------------------------------------------
% Count cliques and output results to appropriate files
% ----------------------------------------------------------------

for i=1:numFiltrations
    for d=1:numDimensions
        for j = 1:Parameters.numControls
           [allCliques, maximalCliques] = ...
             find_cliques_and_maximal_cliques(...
             Graph(logical(distanceGraphs{d, j}{i})), ...
             Parameters.Dimension+1);
            print_cliques_to_perseus_file(maximalCliques, distMaxFix{d,j});
            print_cliques_to_perseus_file(allCliques, distFix{d,j});
        end            
    end
end
    
% ----------------------------------------------------------------
% Close files
% ----------------------------------------------------------------
    
for d=1:numDimensions
    for j=1:Parameters.numControls
        fclose(distFid{d,j});
        fclose(distMaxFid{d,j});
    end
end

% ----------------------------------------------------------------
% Use Perseus to compute persistent homology
% ----------------------------------------------------------------

for d=1:numDimensions
    for j=1:Parameters.numControls
        system(sprintf('%s/perseus nmfsimtop dist_simplices_R%i_%g.s dist_homology_R%i_%g.s',...
            Parameters.PerseusDirectory, dimensionList(d), j,...
            dimensionList(d),j));
    end
end