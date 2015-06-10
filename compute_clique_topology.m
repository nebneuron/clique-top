function [bettiCurves, edgeDensities, persistenceIntervals,...
    unboundedIntervals] = compute_clique_topology ( inputMatrix, varargin ) 

% ----------------------------------------------------------------
% COMPUTE CLIQUE TOPOLOGY
% written by Chad Giusti, 9/2014
%
% Given a symmetric real matrix, construct its order complex, a 
% family of graphs filtered by graph density with edges added in 
% order of decreasing corrsponding entry in the matrix. Enumerate
% cliques in this family of graphs and run Perseus to compute the
% persistent homology of the resulting clique complexes. Return 
% both the aggregate Betti curves and the distribution of 
% persistence lifetimes for the order complex of the matrix.
%
% SYNTAX:
%  compute_clique_topology( inputMatrix )
%  compute_clique_topology( inputMatrix, 'ParameterName', param, ... )
% 
% INPUTS:
%	inputMatrix: an NxN symmetric matrix with real coefficients
% OPTIONAL PARAMETERS:
%   'ReportProgress': displays status and time elapsed in each stage
%       as computation progresses (default: false)
%	'MaxBettiNumber': positive integer specifying maximum Betti 
%		number to compute (default: 3)
%	'MaxEdgeDensity': maximum graph density to include in the
%		order complex in range (0, 1] (default: .6)
%	'FilePrefix': prefix for intermediate computation files,
%		useful for multiple simultaneous jobs
%		(default: 'matrix')
%   'ComputeBetti0': boolean flag for keeping Betti 0 
%       computations; this shifts the indexing of the
%       outputs so that column n represents Betti (n-1).
%       (default: false)
%	'KeepFiles': boolean flag indicating whether to keep
%		intermediate files when the computation 
%		is complete (default: false)
%	'WorkDirectory': directory in which to keep intermediate
%		files during computation (default: current 
%		directory, '.')
%   'BaseDirectory': location of the CliqueTop matlab files
%       (default: detected by which('compute_clique_topology'))
%   'WriteMaximalCliques': boolean flag indicating whether
%       to create a separate file containing the maximal cliques
%       in each graph. May slow process. (default: false)
%   'Algorithm': which version of the clique enumeration algorithm
%       to use. Options are: 'split', 'combine' and 'naive'. 'split'
%       is the version used for the data processing in "Clique topology
%       reveals intrinsic structure in neural correlations". It is
%       usually the most memory-efficient algorithm, but requires the
%       user to "guess" a maximum density and compute a list of cliques 
%       using Cliquer, which must also be compiled using MEX. 'combine'
%       is much less memory efficient, but constructs a list of maximal
%       cliques starting from the first filtration and building upward.
%       'naive' does not construct maximal cliques, but instead enumerates
%       all cliques of sizes necessary to compute Bettis in the specified
%       range. It is very memory efficient but slow, and works well for
%       large matrices. It is incompatible with 'WriteMaximalCliques'.
%
% OUTPUTS:
%	bettiCurves: rectangular array of size 
%		maxHomDim x floor(maxGraphDensity * (N choose 2)) 
%		whose rows are the Betti curves B_1 ... B_maxHomDim
%		across the order complex
%   edgeDensities: the edge densities of the graphs in the
%       order complex, useful for x-axis labels when graphing
%	persistenceIntervals: rectangular array of size
%		maxHomDim x floor(maxGraphDensity * (N choose 2)) 
%       whose rows are counts of the persistence lifetimes
%       in each homological dimension. 
%   unboundedIntervals: vector of length maxHomDim whose
%       entries are the number of unbounded persistence intervals
%       for each dimension. Here, unbounded should be interpreted 
%       as meaning that the cycle disappears after maxGraphDensity
%       as all cycles disappear by density 1.
%
% ----------------------------------------------------------------

% ----------------------------------------------------------------
% Validate and set parameters
% ----------------------------------------------------------------

p = inputParser;
defaultReportProgress = false;
defaultBettiNumber = 3;
defaultEdgeDensity = .6;
defaultBetti0 = false;
defaultFilePrefix = 'matrix';
defaultKeepFiles = false;
defaultWorkDirectory = '.';
defaultWriteMaxCliques = false;
defaultAlgorithm = 'naive';
defaultThreads = 1;
functionLocation = which('compute_clique_topology');
defaultBaseDirectory = fileparts(functionLocation);

addRequired(p, 'inputMatrix', @(x) isreal(x) && isequal(x, x'));
addOptional(p, 'ReportProgress', defaultReportProgress, ...
    @(x) islogical(x) && isscalar(x) );
addOptional(p, 'MaxBettiNumber', defaultBettiNumber, ...
    @(x) isreal(x) && isscalar(x) && (floor(x) == x) && x > 0);
addOptional(p, 'ComputeBetti0', defaultBetti0, ...
    @(x) islogical(x) && isscalar(x) );
addOptional(p, 'MaxEdgeDensity', defaultEdgeDensity, ...
    @(x) isreal(x) && (x > 0) && (x <= 1) );
addOptional(p, 'FilePrefix', defaultFilePrefix, @ischar );
addOptional(p, 'KeepFiles', defaultKeepFiles, ...
    @(x) islogical(x) && isscalar(x) );
addOptional(p, 'WriteMaximalCliques', defaultWriteMaxCliques, ...
    @(x) islogical(x) && isscalar(x) );
addOptional(p, 'WorkDirectory', defaultWorkDirectory, ...
    @(x) exist(x, 'dir') );
addOptional(p, 'BaseDirectory', defaultBaseDirectory, ...
    @(x) exist(x, 'dir'));
addOptional(p, 'Algorithm', defaultAlgorithm, ...
    @(x) any(strcmp(x, {'naive', 'split', 'combine', 'parnaive'})));
addOptional(p, 'Threads', defaultThreads, ...
    @(x) isscalar(x) && (x > 0));

parse(p,inputMatrix,varargin{:});

inputMatrix = p.Results.inputMatrix;
reportProgress = p.Results.ReportProgress;
maxBettiNumber = p.Results.MaxBettiNumber;
computeBetti0 = p.Results.ComputeBetti0;
maxEdgeDensity = p.Results.MaxEdgeDensity;
filePrefix = p.Results.FilePrefix;
keepFiles = p.Results.KeepFiles;
baseDirectory = p.Results.BaseDirectory;
workDirectory = p.Results.WorkDirectory;
writeMaximalCliques = p.Results.WriteMaximalCliques;
algorithm = p.Results.Algorithm;
numThreads = floor(p.Results.Threads);

if ispc
    perseusDirectory = [baseDirectory '\perseus'];
    neuralCodewareDirectory = [baseDirectory '\Neural_Codeware'];
else
    perseusDirectory = [baseDirectory '/perseus'];
    neuralCodewareDirectory = [baseDirectory '/Neural_Codeware'];
end

if ((strcmp(algorithm, 'naive') || strcmp(algorithm, 'parnaive')) && writeMaximalCliques)
    error('Naive clique enumeration and WriteMaximalCliques are incompatible');
end

if (strcmp(algorithm, 'parnaive')) 
    
end

% ----------------------------------------------------------------
% If we need Cliquer, make sure the files are compiled
% ----------------------------------------------------------------

if (strcmp(algorithm, 'split')) 
    if ~exist(sprintf('./Neural_Codeware/+Cliquer/FindAll.%s', mexext), 'file')
        disp('MEX Cliquer not compiled. Compiling before beginning process.')
        
        startFolder = cd(fileparts(which('compute_clique_topology.m')));
        cd('Neural_Codeware');

        Cliquer.Compile();

        cd(startFolder);
    end
end

% ----------------------------------------------------------------
% Ensure that the diagonal is zero
% ----------------------------------------------------------------

inputMatrix(logical(eye(size(inputMatrix,1)))) = 0;

% ----------------------------------------------------------------
% Move to working directoy and stop if files might be overwritten
% ----------------------------------------------------------------


path(neuralCodewareDirectory, path);

try 
    cd(workDirectory);
    if exist(sprintf('%s/%s_max_simplices.txt', workDirectory, filePrefix), 'file')
        error('File %s_max_simplices.txt already exists in directory %s.',...
            filePrefix, workDirectory);
    end
    if exist(sprintf('%s/%s_simplices.txt', workDirectory,  filePrefix), 'file')
        error('File %s_simplices.txt already exists in directory %s.',...
            filePrefix, workDirectory);
    end
    if exist(sprintf('%s/%s_homology_betti.txt', workDirectory,  filePrefix), 'file')
        error('File %s_homology_betti.txt already exists in directory %s.',...
            filePrefix, workDirectory);
    end
    for d=0:maxBettiNumber+1
        if exist(sprintf('%s/%s_homology_%i.txt', workDirectory,  filePrefix, d), 'file')
            error('File %s_homology_%i.txt already exists in directory %s.',...
                filePrefix, d, workDirectory);
        end
    end
catch exception 
    disp(exception.message);
    rethrow(exception);
end

% ----------------------------------------------------------------
% Enumerate maximal cliques and print to Perseus input file
% ----------------------------------------------------------------

if reportProgress
    toc;
    sprintf('Enumerating cliques using %s algorithm.', algorithm);
    tic;
end

switch algorithm
    case 'combine' 
        numFiltrations = combine_cliques_and_write_to_file(...
            inputMatrix, maxBettiNumber + 2, maxEdgeDensity, filePrefix,...
            writeMaximalCliques);
    case 'naive'
        numFiltrations = naive_enumerate_cliques_and_write_to_file(...
            inputMatrix, maxBettiNumber + 2, maxEdgeDensity, filePrefix);
    case 'parnaive'
        numFiltrations = ...
            parallel_naive_enumerate_cliques_and_write_to_file(...
            inputMatrix, maxBettiNumber + 2, maxEdgeDensity, filePrefix,...
            numThreads );
    case 'split'    
        numFiltrations = split_cliques_and_write_to_file(...
            inputMatrix, maxBettiNumber + 2, maxEdgeDensity, filePrefix,...
            writeMaximalCliques);

end

% ----------------------------------------------------------------
% Use Perseus to compute persistent homology
% ----------------------------------------------------------------

if reportProgress
    toc;
    disp('Using Perseus to compute persistent homology.');
    tic;
end

run_perseus(filePrefix, perseusDirectory);

if reportProgress
    toc;
end

% ----------------------------------------------------------------
% Assemble the results of the computation for output
% ----------------------------------------------------------------

matrixSize = size(inputMatrix, 1);

edgeDensities = (1:numFiltrations) / nchoosek(matrixSize,2);

try
    bettiCurves = read_perseus_bettis(sprintf('%s_homology_betti.txt',...
        filePrefix), numFiltrations, maxBettiNumber, computeBetti0);

    if computeBetti0
        persistenceIntervals = zeros(numFiltrations, maxBettiNumber+1);
        unboundedIntervals = zeros(1,maxBettiNumber+1);
        
        for d=0:maxBettiNumber        
            [persistenceIntervals(:,d+1), unboundedIntervals(d+1) ] =...
                read_persistence_interval_distribution(...
                sprintf('%s_homology_%i.txt', filePrefix, d), ...
                numFiltrations);
        end
    else    
        persistenceIntervals = zeros(numFiltrations, maxBettiNumber);
        unboundedIntervals = zeros(1,maxBettiNumber);
        
        for d=1:maxBettiNumber        
            [persistenceIntervals(:,d), unboundedIntervals(d) ] =...
                read_persistence_interval_distribution(...
                sprintf('%s_homology_%i.txt', filePrefix, d), ...
                numFiltrations);
        end
    end
    
    
catch exception
    disp(exception.message);
    disp('Failure to read Perseus output files. This error has likely occurred due to the Perseus process aborting due to memory limitations. It may be possible to circumvent this difficulty by reducing either the maximum Betti number or the maximum edge density computed. Please see the CliqueTop documentation for details.');
    rethrow(exception);
end

% ----------------------------------------------------------------
% Remove remaining intermediate files if desired
% ----------------------------------------------------------------

if keepFiles == false
    try 
        if exist(sprintf('%s_max_simplices.txt', filePrefix), 'file')
            delete(sprintf('%s_max_simplices.txt', filePrefix));
        end
        if exist(sprintf('%s_simplices.txt', filePrefix), 'file')
            delete(sprintf('%s_simplices.txt', filePrefix));
        end
        if exist(sprintf('%s_homology_betti.txt', filePrefix), 'file')
            delete(sprintf('%s_homology_betti.txt', filePrefix));
        end
        for d=0:maxBettiNumber+1
            if exist(sprintf('%s_homology_%i.txt', filePrefix, d), 'file')
                delete(sprintf('%s_homology_%i.txt', filePrefix, d));
            end
        end
    catch exception
        disp(exception.message);
        rethrow(exception);
    end
end

