function bIsValid = IsValidStream(this)
    %---------------------------------------------------------------------------
    % Usage:
    %    bIsValid = this.IsValidStream()
    % Description:
    %     The calling stream is a valid stream only if the support of each
    %     codeword in code `i` is contained in the support of some codeword
    %     in code `i + 1` for all valid `i`.  Determine whether the calling
    %     stream is valid.
    %---------------------------------------------------------------------------
    
    % This initialization allows the update rule in the for-loop
    % below to work.
    bIsValid = true;

    for i = 2 : StreamLength(this)
        A = ToMatrix(this.Codes{i - 1});
        B = ToMatrix(this.Codes{i});

        bIsValid = (bIsValid && ...
                    all(max(A * B', [], 2) ...
                        == sum(A, 2)));
    end
end