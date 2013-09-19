% ----------------------------------------------------------------
% BUILD SHUFFLED CCG CONTROLS AND COMPUTE BETTIS
%
% Beginning from a CCG matrix, construct a sequence of controls
% by sampling from the maximum entropy distribution on matrices
% induced by "observing" the CCG matrix. For each such control
% matrix, build a family of graphs filtered by edge density. Then 
% count the cliques in each graph in the family and use Perseus to
% compute the betti numbers of these clique complexes.
% 
% This script assumes that parameters have been set using the 
% script SETUP COMPUTATIONS or an equivalent process and that
% a "total" CCG has been built as in BUILD FILTERED MATRICES AND 
% COMPUTE BETTIS
% ----------------------------------------------------------------

% ----------------------------------------------------------------
% Approximate the WME distribution for the degree sequence of the 
% CCG matrix using the method of gradient descent. 
%
% NOTE: As written, this process may not terminate, but it seems
% to do so in practice. This code is ad hoc and awaits a paper 
% by Chris Hillar which discusses more reasonable approaches to
% computing the distribution parameters.
% ----------------------------------------------------------------

degSequence = sum(totalCCG,2);  % degree sequence
relMin = min(degSequence);

theta_err = abs(length(degSequence) - sum(abs(degSequence))); 
guess = 1;
while (theta_err/min(d) > 0.001)
%	disp(sprintf('Finding thetas, guess size = %g, last error = %g', ...
%        guess, theta_err));
    [theta, theta_err] = fminunc(@(th)wme_parameter_error(th,...
	 degSequence), guess*ones(size(d)));
    guess = guess + randi(100);
end
%disp(sprintf('Final theta error= %g', theta_err));

% ----------------------------------------------------------------
% Count cliques in each family of graphs and write these to files
% in a format useable by Perseus to compute filtered homology.
% ----------------------------------------------------------------

for j=1:Parameters.numControls
    count_cliques_and_write_to_file(filteredWMEGraphs{j}, ...
        Parameters.Dimension, 'wme', '', j);
end

% ----------------------------------------------------------------
% Use Perseus to compute persistent homology
% ----------------------------------------------------------------

for j=1:Parameters.numControls
    system(sprintf(...
        '%s/perseus nmfsimtop wme_simplices_%g.s wme_homology_%g.s',...
        Parameters.PerseusDirectory, j, j));
end
