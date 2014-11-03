function mtxSubsets = SubsetsOf(vecIn)
    assert(isrow(vecIn));

    k = nnz(vecIn);
    mtxSubsets = zeros(2^k, length(vecIn));
    mtxSubsets(:, find(vecIn)) = Utils.BinaryVectors(k);

    % Remove the all-zero row (i.e., the empty subset).
    mtxSubsets(1, :) = [];
end