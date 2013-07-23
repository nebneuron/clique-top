% ----------------------------------------------------------------
% COUNT CLIQUES AND RUN PERSEUS
%
% Given sequences of filtered graphs, use Cliquer to count maximal
% cliques and all cliques in the important dimension range, then 
% output these files in a Perseus-compatable format.
%
% This script expects to receive sequences of data, shuffled CCG
% and WME filtered graphs, such as those produced by the script
% BUILD FILTERED MATRICES AND CONTROLS.
% ----------------------------------------------------------------

% ----------------------------------------------------------------
% Open files for output of cliques counted in each filtered family
% of graphs. Data is stored in a format useable by Perseus to 
% compute filtered homology.
% ----------------------------------------------------------------

dataFid = fopen('data_simplices.s', 'w');
dataMaxFid = fopen('data_simplices.s', 'w');

shuffledFid = cell(Parameters.numControls,1);
shuffledMaxFid = cell(Parameters.numControls,1);

wmeFid = cell(Parameters.numControls,1);
wmeMaxFid = cell(Parameters.numControls,1);

for j=1:Parameters.numControls
    shuffledFid{j} = fopen(sprintf('shuffled_ccg_simplices_%g.s',j), 'w');
    fprintf(shuffledFid{j}, '1\n');

    shuffledMaxFid{j} = fopen(sprintf('shuffled_ccg_max_simplices_%g.s',...
        j), 'w');
    fprintf(shuffledMaxFid{j}, '1\n');

    wmeFid{j} = fopen(sprintf('wme_simplices_%g.s',j), 'w');
    fprintf(wmeFid{j}, '1\n');

    wmeMaxFid{j} = fopen(sprintf('wme_max_simplices_%g.s', j), 'w');
    fprintf(wmeMaxFid{j}, '1\n');
end

% ----------------------------------------------------------------
% Count cliques and output results to appropriate files for data 
% and each control
% ----------------------------------------------------------------

for i=1:Parameters.numFiltrations % at each threshold level    
    disp(sprintf('Clique count, threshold %g',i));

    [allCliques, maximalCliques] = ...
     find_cliques_and_maximal_cliques(...
     Graph(logical(filteredCCGGraphs{i})), Parameters.Dimension+1);
    print_cliques_to_perseus_file(maximalCliques, dataMaxFid);
    print_cliques_to_perseus_file(allCliques, dataFid);
         
    for j=1:Parameters.numControls
        [allCliques, maximalCliques] = ...
         find_cliques_and_maximal_cliques(...
         Graph(logical(filteredShuffledCCGGraphs{j}{i})), ...
         Parameters.Dimension+1);
        print_cliques_to_perseus_file(maximalCliques, shuffledMaxFid);
        print_cliques_to_perseus_file(allCliques, shuffledFid);

        [allCliques, maximalCliques] = ...
         find_cliques_and_maximal_cliques(...
         Graph(logical(filteredWMEGraphs{J}{i})), Parameters.Dimension+1);
        print_cliques_to_perseus_file(maximalCliques, wmeMaxFid);
        print_cliques_to_perseus_file(allCliques, wmeFid);
    end
     
end

% ----------------------------------------------------------------
% Close files
% ----------------------------------------------------------------

fclose(dataFid);
fclose(dataMaxFid);
        
for j=1:Parameters.numControls
    fclose(shuffledFid{j});
    fclose(shuffledMaxFid{j});
    fclose(wmeFid{j});
    fclose(wmeMaxFid{j});
end

% ----------------------------------------------------------------
% Use Perseus to compute persistent homology
% ----------------------------------------------------------------

system(sprintf('%s/perseus nmfsimtop data_simplices.s data_homology.s',...
    Parameters.PerseusDirectory));
for j=1:Parameters.numControls
    system(sprintf('%s/perseus nmfsimtop shuffled_ccg_simplices_%g.s shuffled_ccg_homology_%g.s',...
        Parameters.PerseusDirectory, j,j));
    system(sprintf(...
        '%s/perseus nmfsimtop wme_simplices_%g.s wme_homology_%g.s',...
        Parameters.PerseusDirectory, j, j));
end
