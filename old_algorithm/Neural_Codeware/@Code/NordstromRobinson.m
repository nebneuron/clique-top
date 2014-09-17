function code = NordstromRobinson()
    %---------------------------------------------------------------------------
    % Usage:
    %    code = Code.NordstromRobinson()
    % Description:
    %    Create the Nordstrom-Robinson code.
    %---------------------------------------------------------------------------
    
    % This construction of the Nordstrom-Robinson code comes from Huffman & Pless.
    % First generate the extended Golay code.  This construction requires the entries
    % of the Golay code to be in a specific order; the variables 'first8' and 'last16'
    % store the first 8 entries and the last 16 entries of the codewords in the
    % appropriate order.  The variable 'numOnes' counts the number of ones in the
    % first 8 entries.
    codeGolay = LinearCode.Golay();
    first8   = codeGolay.mxCodewords(:, [12, 13, 15, 16, 18, 19, 20, 24]);
    last16   = codeGolay.mxCodewords(:, [1 2 3 4 5 6 7 8 9 10 11 14 17 21 22 23]);
    numOnes  = sum(first8, 2);

    % With the above setup, the codewords of the Nordstrom-Robinson code are the
    % last 16 entries of the Golay codewords whose first 8 entries are all zeros
    % or whose first 8 entries contain exactly 2 ones, one of which is the first
    % entry of the codeword.
    mtxCode = last16( (numOnes == 0) | (numOnes == 2 & first8(:, 1) == 1), : );
    code = Code(mtxCode);
end