function tab = RJMCMC(tab,T,Cov_g,Cov_T,ichain,imcmc)
global applyXi
LogLc = tab(1,1);
Nnode = tab(1,2);
Xigc = tab(1,3);
XiTc = tab(1,4);
[xzc, rhoc, susc] = Chian2xz(tab);
step = select_step(Nnode);
% step = select_step_108010(Nnode);
% step = select_step_404020(Nnode);

if step == 91 %birth
    [LogLc,xzc,rhoc,susc] = birth(LogLc,xzc,rhoc,susc,Xigc,XiTc,T,Cov_g,Cov_T);
elseif step == 92 %death
    [LogLc,xzc,rhoc,susc] = death(LogLc,xzc,rhoc,susc,Xigc,XiTc,T,Cov_g,Cov_T);
else
    [LogLc,xzc,rhoc,susc,rg,rT] = move(LogLc,xzc,rhoc,susc,Xigc,XiTc,T,ichain,Cov_g,Cov_T);
    if  applyXi == 1
        [LogLc,Xigc,XiTc] = Xi_perturb(LogLc,xzc,Xigc,XiTc,T,ichain,Cov_g,Cov_T,rg,rT);
    end
end
tab = zeros(size(tab));
tab(1,1:4+numel(xzc)+numel(rhoc)+numel(susc))=[LogLc size(xzc,2) Xigc XiTc reshape(xzc',1,numel(xzc)) rhoc susc];

if rem(imcmc,2000)==0
    disp(['T: ', num2str(T),', Iteration: ',num2str(imcmc),', LogL: ',num2str(LogLc),', k: ',num2str(size(xzc,2)),', Xig: ',num2str(Xigc),', XiT: ',num2str(XiTc)])
end
end