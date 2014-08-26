function display(this, iNumToDisplay)
    %--------------------------------------------------------------------------------
    % Usage:
    %    clln.display(iNumToDisplay)
    % Description:
    %    Display part of this `Collection`.
    % Arguments:
    %    iNumToDisplay (default: 20)
    %       The maximum number of elements to display.
    %--------------------------------------------------------------------------------
    
    if nargin < 2
        iNumToDisplay = 20;
    end

    disp(' ');
    disp([inputname(1) ' = ']);
    disp(' ');

    disp(['   `Collection` object with n = ' num2str(n(this)) ...
          ' containing elements...']);

    for i = 1 : min(iNumToDisplay, Size(this))
        disp(['      ' num2str(find(this.Sets(i, :)))]);
    end

    disp(' ');

    if iNumToDisplay < Size(this)
        disp(['   ...displaying ' num2str(iNumToDisplay) ' of ' ...
              num2str(Size(this)) ' elements.  Use `' inputname(1) ...
              '.display(num)` to see `num` elements.']);

        disp(' ');
    end
end