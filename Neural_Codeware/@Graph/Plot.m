function Plot(this, mtxCoords)
    %--------------------------------------------------------------------------
    % Usage:
    %    obj.Plot(mtxCoords)
    % Description:
    %    Plot the calling graph object.
    % Arguments:
    %    mtxCoords (optional)
    %       A matrix with two columns whose rows provide the locations
    %       for vertices in the resultant plot.  Defaults to
    %       evenly-spaced points around the unit circle.
    %--------------------------------------------------------------------------
    
    if nargin < 2
        iVerts = Size(this);
        
        t = linspace(0, 2 * pi * (1 - 1 / iVerts), iVerts)';
        mtxCoords = [cos(t), sin(t)];
    end
    
    gplot(ToMatrix(this), mtxCoords, '-*')
end