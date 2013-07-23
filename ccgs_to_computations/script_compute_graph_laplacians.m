% ----------------------------------------------------------------
% COMPUTE GRAPH LAPLACIANS
%
% Compute graph Laplacians and spectra of such for the data
% and control CCG matrices, as well as their filtered versions.
%
% This script assumes that a total CCG matrix and filtered 
% families of shuffled CCG/WME controls have been computed using
% the BUILD FILTERED MATRICES AND CONTROLS script or an 
% equivalent process.
% ----------------------------------------------------------------

% ----------------------------------------------------------------
% Compute the weighted graph Laplacian and its spectra for the 
% data CCG matrix, the shuffled CCG matrices, and the sampled
% WME matrices.
% ----------------------------------------------------------------

totalCCGLaplacian = weighted_matrix_laplacian(totalCCG);
totalCCGLaplacianEigenvalues = eig(totalCCGLaplacian);

shuffledCCGLaplacian = cell(Parameters.numControls,1);
shuffledCCGLaplacianEigenvalues = cell(Parameters.numControls,1);
WMELaplacian = cell(Parameters.numControls,1);
WMELaplacianEigenvalues = cell(Parameters.numControls,1);

for j=1:Parameters.numControls
    shuffledCCGLaplacian{j} = ...
        weighted_matrix_laplacian(shuffledTotalCCG{j});
    shuffledCCGLaplacianEigenvalues{j} = eig(shuffledCCGLaplacian{j});
    
    WMELaplacian{j} = weighted_matrix_laplacian(WMEGraphs{j});
    WMELaplacianEigenvalues{j} = eig(WMELaplacian{j});
end

% ----------------------------------------------------------------
% For each filtered family of graphs, compute the Laplacians of 
% their adjacency matrices and the associated spectra.
% ----------------------------------------------------------------

filteredTotalCCGLaplacian = cell(Parameters.numFiltrations,1);
filteredTotalCCGLaplacianEigenvalues = cell(Parameters.numFiltrations,1);
filteredShuffledCCGLaplacian = cell(Parameters.numControls,1);
filteredShuffledCCGLaplacianEigenvalues = cell(Parameters.numControls,1);
filteredWMELaplacian = cell(Parameters.numControls,1);
filteredWMELaplacianEigenvalues = cell(Parameters.numControls,1);

for j=1:Parameters.numControls
    filteredShuffledCCGLaplacian{j} = cell(Parameters.numFiltrations,1);
    filteredShuffledCCGLaplacianEigenvalues{j} = cell(Parameters.numFiltrations,1);
    filteredWMELaplacian{j} = cell(Parameters.numFiltrations,1);
    filteredWMELaplacianEigenvalues{j} = cell(Parameters.numFiltrations,1);
end

for i=1:Parameters.numFiltrations
    filteredTotalCCGLaplacian{i} = weighted_matrix_laplacian(filteredCCGGraphs{i});
    filteredTotalCCGLaplacianEigenvalues{i} = eig(filteredTotalCCGLaplacian{i});
    
    for j=1:Parameters.numControls
        filteredShuffledCCGLaplacian{j}{i} = weighted_matrix_laplacian(filteredShuffledCCGGraphs{j}{i});
        filteredShuffledCCGLaplacianEigenvalues{j}{i} = eig(filteredShuffledCCGLaplacian{j}{i});
        filteredWMELaplacian{j}{i} = weighted_matrix_laplacian(filteredWMEGraphs{j}{i});
        filteredWMELaplacianEigenvalues{j}{i} = eig(filteredWMELaplacian{j}{i});
    end
end

% ----------------------------------------------------------------
% Rearrange the data in the computation of the families of 
% Eigenvalues into matrices for ease of manipulation
% ----------------------------------------------------------------

allDataLaplacianEigenvalues = zeros(Parameters.numFiltrations, size(totalCCG,1));
meanSCCGLaplacianEigenvalues = zeros(Parameters.numFiltrations, size(totalCCG,1));
meanWMELaplacianEigenvalues = zeros(Parameters.numFiltrations, size(totalCCG,1));

sampleSCCGLaplacianEigenvalues = cell(Parameters.numControls);
sampleWMELaplacianEigenvalues = cell(Parameters.numControls);
for j=1:Parameters.numControls
    sampleSCCGLaplacianEigenvalues{j} = zeros(Parameters.numFiltrations, size(totalCCG,1));
    sampleWMELaplacianEigenvalues{j} = zeros(Parameters.numFiltrations, size(totalCCG,1));
end

for i=1:Parameters.numFiltrations
    allDataLaplacianEigenvalues(i,:) = filteredTotalCCGLaplacianEigenvalues{i};
    for j=1;Parameters.numControls
        sampleSCCGLaplacianEigenvalues{j}(i, :) = filteredShuffledCCGLaplacianEigenvalues{j}{i};
        sampleWMELaplacianEigenvalues{j}(i, :) = filteredWMELaplacianEigenvalues{j}{i};
        meanSCCGLaplacianEigenvalues(i, :) = meanSCCGLaplacianEigenvalues(i, :) + filteredShuffledCCGLaplacianEigenvalues{j}{i}';
        meanWMELaplacianEigenvalues(i, :) = meanWMELaplacianEigenvalues(i, :) + filteredWMELaplacianEigenvalues{j}{i}';
    end
end
meanSCCGLaplacianEigenvalues = meanSCCGLaplacianEigenvalues / Parameters.numControls;
meanWMELaplacianEigenvalues = meanWMELaplacianEigenvalues / Parameters.numControls;