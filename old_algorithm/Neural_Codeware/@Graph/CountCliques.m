function iNum = CountCliques(this, iMin, iMax, bMaximal)
    %--------------------------------------------------------------------------
    % Usage:
    %    iNum = obj.CountCliques(iMin, iMax, bMaximal)
    % Description:
    %    Count the number of the cliques within the given size range in the
    %    calling graph.
    % Arguments:
    %    iMin (default: 1)
    %       The minimum size of the cliques to be found.  Must be positive.
    %    iMax (default: 0)
    %       The maximum size of the cliques to be found.  Must be nonnegative.
    %       Set to zero to have no upper bound on clique size.
    %    bMaximal (default: false)
    %       A boolean (true/false) input that is `true` if only maximal cliques
    %       should be counted and `false` if all cliques are to be counted.
    %--------------------------------------------------------------------------

    if nargin < 4 || isempty(bMaximal)
        bMaximal = false;
    end;

    if nargin < 3 || isempty(iMax)
        iMax = 0; % no limit on clique size
    end;

    if nargin < 2 || isempty(iMin)
        iMin = 1;
    end;

    iMaxNumCliques = 0;

    iNum = Cliquer.FindAll(ToMatrix(this), iMin, iMax, bMaximal, iMaxNumCliques);
end