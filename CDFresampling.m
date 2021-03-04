function Chain_after = CDFresampling(Chain,Nchain_requested)
Nchain = size(Chain,1);
Chain_after = Chain;
Chain(1:floor(Nchain/2),:) = [];             %throw away the first half chains
maxLogL_ind = find(Chain(:,1)==max(Chain(:,1)),1);
LogL_vector = Chain(:,1);                  % sample from all chains
LogL_vector = LogL_vector - min(LogL_vector);
LogL_CDF = cumsum(LogL_vector);
LogL_CDF_NRMZ = LogL_CDF ./ max(LogL_CDF);
% figure, plot(LogL_CDF_NRMZ), hold on, plot(LogL_CDF_NRMZ,'rx')
Log_L = zeros(Nchain_requested,2);
for i = 1:Nchain_requested-1
    rnd = LogL_CDF_NRMZ - rand();
    index = find(rnd == min(rnd(rnd>=0)));
    index = index(1);
    Log_L(i,1:2) = [Chain(index,1), index];
end
Log_L(Nchain_requested,1:2) = [Chain(maxLogL_ind,1), maxLogL_ind];
LogLsorted = sortrows(Log_L);
for i=1:Nchain_requested
    Chain_after(i,:) = Chain(LogLsorted(i,2),:);
end
Chain_after = Chain_after(1:Nchain_requested,:);
end
