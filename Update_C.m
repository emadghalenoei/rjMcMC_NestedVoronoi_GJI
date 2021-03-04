function [Cov_g, Cov_T] = Update_C(Chain)
Chain_maxL = topkrows(Chain,1,'descend');  % find chain with the highest LogL
[xz, rho, sus] = Chian2xz(Chain_maxL);
[DensityMap, SusMap] = xz2model(xz(1,:),xz(2,:),rho, sus);
[rg_maxL, rT_maxL] = ForwardModel(DensityMap, SusMap);
Cov_g = rg2Cov_g(rg_maxL);
Cov_T = rT2Cov_T(rT_maxL);
end