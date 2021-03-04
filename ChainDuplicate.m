function Chain_after = ChainDuplicate(Chain,Nchain_requested)
Chain_maxL = topkrows(Chain,1,'descend');
Chain_after = repelem(Chain_maxL,Nchain_requested,1);
end
