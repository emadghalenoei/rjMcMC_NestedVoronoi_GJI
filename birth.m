function [LogLc,xzc,rhoc,susc] = birth(LogLc,xzc,rhoc,susc,Xigc,XiTc,T,Cov_g,Cov_T)
global applyXi applyUpdate z_min_voronoi
xp = rand(1);
zp = z_min_voronoi+rand(1)*(1-z_min_voronoi);
[identity_p, kcell] = Identify(xzc(1,1:3),xzc(2,1:3),xp,zp);
[rhop,susp] = identity2rhosuc(identity_p);
xzp = [xzc, [xp ; zp]];
rhop = [rhoc, rhop];
susp = [susc, susp];
[DensityMap, SusMap] = xz2model(xzp(1,:),xzp(2,:),rhop, susp);
[rg, rT] = ForwardModel(DensityMap, SusMap);
if (applyXi == 0) && (applyUpdate == 0)
    Cov_g = rg2Cov_g(rg);
    Cov_T = rT2Cov_T(rT);
end
LogLp = Log_Likelihood(rg,Cov_g,Xigc,rT,Cov_T,XiTc);
MHP = exp((LogLp - LogLc)/T);
if rand()<=MHP
    xzc = xzp;
    rhoc =  rhop;
    susc =  susp;
    LogLc = LogLp;
end
end