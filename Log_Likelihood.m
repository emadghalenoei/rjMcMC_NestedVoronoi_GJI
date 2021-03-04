function LogL = Log_Likelihood(rg,Cov_g,Xig,rT,Cov_T,XiT)
Cov_g = Xig * Cov_g;
Lg = chol(Cov_g,'lower');
LogLg =  - sum(log(diag(Lg))) - (rg'*(Cov_g^-1)*rg)/2;
Cov_T = XiT * Cov_T;
LT = chol(Cov_T,'lower');
LogLT =  - sum(log(diag(LT))) - (rT'*(Cov_T^-1)*rT)/2;
LogL = LogLg + LogLT;
% LogL = 0;
end