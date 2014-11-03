function codeNew = Shuffle(this)
    %---------------------------------------------------------------------------
    % Usage:
    %    codeNew = this.Shuffle()
    % Description:
    %    Create a shuffled version of the calling code; that is, create a
    %    code with the same weight distribution as the calling code.
    %---------------------------------------------------------------------------
    
    mtxOld = ToMatrix(this);
    
    iSize = Size(this);
    iLength = Length(this);

    mtxNew = zeros(iSize, iLength);
    
    for i = 1 : iSize
        bFoundNewWord = false;
        
        while ~bFoundNewWord
            rvNewWord = mtxOld(i, randperm(iLength));
            
            if ~isempty(setdiff(rvNewWord, mtxNew(1 : i - 1, :), 'rows'))
                mtxNew(i, :) = rvNewWord;
                bFoundNewWord = true;
            end
        end
    end
    
    codeNew = Code(mtxNew);
end