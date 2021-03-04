function [LogLc,xzc,rhoc,susc] =death(LogLc,xzc,rhoc,susc,Xigc,XiTc,T,Cov_g,Cov_T)
global applyXi applyUpdate
i = randi([4,length(xzc(1,:))],1,1);
xzp = xzc;
rhop = rhoc;
susp = susc;
% [identity_p, kcell] = Identify(xzc(1,1:3),xzc(2,1:3),xzc(1, i),xzc(2, i));
xzp(:, i) = [];
rhop(i-3) = [];
susp(i-3) = [];
[DensityMap, SusMap] = xz2model(xzp(1,:),xzp(2,:),rhop, susp);
[rg, rT] = ForwardModel(DensityMap, SusMap);
if (applyXi == 0) && (applyUpdate == 0)
    Cov_g = rg2Cov_g(rg);
    Cov_T = rT2Cov_T(rT);
end
LogLp = Log_Likelihood(rg,Cov_g,Xigc,rT,Cov_T,XiTc);
MHP =  exp((LogLp - LogLc)/T);
if rand()<=MHP
    xzc = xzp;
    rhoc =  rhop;
    susc =  susp;
    LogLc = LogLp;
end
end