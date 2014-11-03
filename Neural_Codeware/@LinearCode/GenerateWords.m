function cllnWords = GenerateWords(mtxGenerator, bIsFullRank)
    %---------------------------------------------------------------------------
    % Usage:
    %    cllnWords = GenerateWords(mtxGenerator, bIsFullRank)
    % Description:
    %    Generate the words in the binary linear code with the given
    %    generator matrix.
    % Arguments:
    %    mtxGenerator
    %       The generator matrix of this code; the resultant code is the row
    %       span of this matrix.
    %    bIsFullRank
    %       If this is `true`, then the generator matrix is assumed to be
    %       full-rank and no checking is done to ensure that all codewords
    %       are distinct; if it is `false`, all resultant codewords are
    %       guaranteed to be distinct.
    %---------------------------------------------------------------------------
    
    % Get the number of rows in the generator matrix.
    k = size(mtxGenerator, 1);

    % Create the code by finding all `2^k` binary linear combinations of the
    % generator matrix's rows.
    mtxWords = mod(Utils.BinaryVectors(k) * mtxGenerator, 2);
    
    % The method below is slower but more memory efficient than the one
    % above.
    %     if (k < 16)
    %         mtxBinaryVectors = ( dec2bin([0 : 2^k - 1]) == '1' );
    %         mtxWords = mod(mtxBinaryVectors * mtxGenerator, 2);
    %     else
    %         r = 15;
    %         mtxWords = zeros(2^k, size(mtxGenerator, 2));
    %      
    %         for ii = (1 : 2^(k-r))
    %             rvNums = (ii - 1 : ii - 1 + 2^r);
    %             mtxBinaryVectors = ( dec2bin(rvNums, k) == '1' );
    %             mtxTemp = mod(mtxBinaryVectors * mtxGenerator, 2);
    %             mtxWords(rvNums + 1, :) = mtxTemp;
    %         end
    %     end
    
    % Return the collection of words; if the matrix is not full-rank, ensure
    % that the returned codewords are distinct.
    if bIsFullRank
        cllnWords = Collection(mtxWords);
    else
        cllnWords = Collection(unique(mtxWords, 'rows'));
    end
end