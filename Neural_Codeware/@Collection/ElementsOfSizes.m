function cllnOut = ElementsOfSizes(this, vecSizes)
    vecSizes = unique(vecSizes);
    
    cllnOut = this(ismember(sum(ToMatrix(this), 2), vecSizes));
end