function [ bettiCurves ] = draw_betti_curves( filePrefix, fileSuffix,...
    numRuns, pStep, maxP, maxDim, lineStyle, lineWidth, graphHandle,...
    colorProgression)

% ----------------------------------------------------------------
% DRAW BETTI CURVES
%
% From Perseus output file, draw the betti curves. If multiple
% runs of a control are being drawn, draw the mean betti curves.
% Omits Betti 0.
%
% INPUT:
%   filePrefix: Prefix in Perseus output file name
%   fileSuffix: Suffix in Perseus output file name
%   numRuns: Number of control runs to average over. Set to zero
%       if the files aren't indexed by a run number.
%   pStep: Size of graph density step in filtration
%   maxP: Max graph density in filtration. Both of these 
%       parameters are used for constructing the x-axis of
%       the graph.
%   maxDim: Maximum Betti curve dimension to compute.
%   lineStyle: String specifyingline style in which to draw the 
%       curves, eg. '--'
%   lineWidth: Integer specification of line width for curves
%   graphHandle: Handle of parent axis into which to draw the graph
%   colorProgression: Array of RGB specifications for Betti curve
%       colors
%
% OUTPUT:
%   bettiCurves: Data points for curves plotted.
% ----------------------------------------------------------------

numFiltrations = maxP/pStep + 1;
p = 0:pStep:maxP;

if (numRuns > 0)
    allBettis = zeros(numRuns, numFiltrations, maxDim + 1);
    for i=1:numRuns
        allBettis(i,:,:) = read_perseus_bettis(...
            sprintf('%s_homology%s_%i.s_betti.txt', filePrefix, ...
            fileSuffix, i), numFiltrations, maxDim);
    end
    bettiCurves = squeeze(mean(allBettis,1));
else
    bettiCurves = read_perseus_bettis(sprintf(...
        '%s_homology%s.s_betti.txt', filePrefix, fileSuffix), ...
        numFiltrations, maxDim);
end     

axes(graphHandle);
hold on;

for i=1:maxDim
    plot(p, bettiCurves(:,i+1), 'Color', colorProgression(i,:), ...
        'LineWidth', lineWidth, 'LineStyle', lineStyle);
end

hold off;
end

