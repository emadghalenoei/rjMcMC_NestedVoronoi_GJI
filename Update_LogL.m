function Chain = Update_LogL(Chain,Cov_g, Cov_T)
Nchain = size(Chain,1);
for ichain = 1:Nchain
    [xz, rho, sus] = Chian2xz(Chain(ichain,:));
    [DensityMap, SusMap] = xz2model(xz(1,:),xz(2,:),rho, sus);
    [rg, rT] = ForwardModel(DensityMap, SusMap);
    Xig = Chain(ichain,3);
    XiT = Chain(ichain,4);
    Chain(ichain,1) = Log_Likelihood(rg,Cov_g,Xig,rT,Cov_T,XiT);
end
end