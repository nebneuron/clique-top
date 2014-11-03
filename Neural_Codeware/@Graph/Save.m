function Save(this, strFile)
    %--------------------------------------------------------------------------
    % Usage:
    %    obj.Save(strFile)
    % Description:
    %    Save this graph in DIMACS ASCII format to the given file.
    % Arguments:
    %    strFile
    %       The file to which this graph should be saved.  This file will be
    %       created if it does not already exist.  If the file already
    %       exists, it will be overwritten without prompt.
    %--------------------------------------------------------------------------
    
    assert(nargin == 2, 'A file location must be provided.');
        
    mtx = ToMatrix(this);
    
    file = fopen(strFile, 'w');
    
    %strData = ['p edge ' num2str(Size(this)) ' ' num2str(nnz(mtx) / 2) '\n'];
    fprintf(file, 'p edge %u %u\n', Size(this), nnz(mtx) / 2);
    
    [I, J] = find(triu(mtx, 1));
    
    for i = 1 : length(I)
        %strData = [strData 'e ' num2str(I(i)) ' ' num2str(J(i))];
        fprintf(file, 'e %u %u\n', I(i), J(i));
    end
    
    fclose(file);
end