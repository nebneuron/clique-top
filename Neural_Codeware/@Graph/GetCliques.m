function cllnCliques = GetCliques(this, iMin, iMax, bMaximal)
    %--------------------------------------------------------------------------
    % Usage:
    %    cllnCliques = gph.GetCliques(iMin, iMax, bMaximal)
    % Description:
    %    Return a `Collection` object containing all cliques within the given
    %    size range in the calling graph.
    % Arguments:
    %    iMin
    %       The minimum size of the cliques to be found.  Must be positive.
    %    iMax
    %       The maximum size of the cliques to be found.  Must be nonnegative.
    %       Set to zero to have no upper bound on clique size.
    %    bMaximal
    %       A boolean (true/false) input that is `true` if only maximal cliques
    %       should be counted and `false` if all cliques are to be counted.
    %--------------------------------------------------------------------------

    % This method is not ideal and requires that we do twice the work as what
    % should be required.  Fix it if you have a better algorithm.  The problem
    % is that Cliquer is limited to returning a predetermined maximum number of cliques but
    % we don't have a nice upper bound on the number of cliques (2^n is not
    % nice).
    % IDEA: Set the fifth parameter of `Cliquer.FindAll` to the maximum
    % size of an integer on this platform; this should really probabaly be
    % handled in the MEX file for `Cliquer.FindAll`.

    if nargin < 4 || isempty(bMaximal)
        bMaximal = false;
    end

    if nargin < 3 || isempty(iMax)
        iMax = 0; % no limit on clique size
    end

    if nargin < 2 || isempty(iMin)
        iMin = 1;
    end

    iNumCliques = CountCliques(this, iMin, iMax, bMaximal);

    [~, mtxCliques] = Cliquer.FindAll(ToMatrix(this), iMin, iMax, bMaximal, iNumCliques);

    cllnCliques = Collection(mtxCliques);
end