function run_perseus(filePrefix, fileSuffix, runCounter,...
    perseusDirectory)

% ----------------------------------------------------------------
% RUN PERSEUS
%
% Given a Perseus input file of the form generated by 
% count_cliques_and_write_to_file, run the Perseus algorithm to 
% compute the persistent homology of the given clique complex.
%
% INPUT:
%   filePrefix: Prefix of clique file name
%   fileSuffix: Suffix of clique file name
%   runCounter: Number to append to clique file name -- intended
%       for control runs with the same base file data. Set to zero
%       to omit adding a counter.
%   perseusDirectory: Directory in which the compiled Perseus code
%       is located
%
% ----------------------------------------------------------------

if (runCounter > 0)
    system(sprintf(...
       '%s/perseus nmfsimtop %s_simplices%s_%i.s %s_homology%s_%i',...
        perseusDirectory, filePrefix, fileSuffix, runCounter,...
        filePrefix, fileSuffix, runCounter));
else
    system(sprintf(...
       '%s/perseus nmfsimtop %s_simplices%s.s %s_homology%s',...
        perseusDirectory, filePrefix, fileSuffix, filePrefix, ...
        fileSuffix));
end    

end
