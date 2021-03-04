function [LogLc,Xigc,XiTc] = Xi_perturb(LogLc,xzc,Xigc,XiTc,T,ichain,Cov_g,Cov_T,rg,rT)
global Xi_min Xi_max acpt_total acpt_counter
Nnode=size(xzc,2);
Npar = 4*Nnode-6;
Xistepsize = 0.6;
for i=1:2
    Xigp = Xigc;
    XiTp = XiTc;
    if i==1
        Xigp = cauchy_dist(Xigc,Xistepsize,[1,1],Xi_min,Xi_max,Xigc);
    elseif i==2
        XiTp = cauchy_dist(XiTc,Xistepsize,[1,1],Xi_min,Xi_max,XiTc);
    end
    LogLp = Log_Likelihood(rg,Cov_g,Xigp,rT,Cov_T,XiTp);
    p=exp((LogLp - LogLc)/T);
    if rand()<=p
        LogLc=LogLp;
        Xigc = Xigp;
        XiTc = XiTp;
        acpt_counter(Npar+i,Nnode,ichain) = acpt_counter(Npar+i,Nnode,ichain) + 1;
    end
    acpt_total(Npar+i,Nnode,ichain) = acpt_total(Npar+i,Nnode,ichain) + 1;
end
end