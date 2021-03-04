function Chain = Initializing(Nchain)
global Kmin Kmax  fpath C_original_grv C_original_rtp z_min_voronoi
Chain=zeros(Nchain,4+(Kmax*2)+2*(Kmax-3));
Nnode = Kmin+6;
xc = rand(1,Nnode);
zc = z_min_voronoi+rand(1,Nnode).*(1-z_min_voronoi);
xzc = [xc; zc];
[identity, kcell] = Identify(xzc(1,1:3),xzc(2,1:3),xzc(1,4:end),xzc(2,4:end));
[rhoc,susc] = identity2rhosuc(identity);

% load Chain00.mat Chain
% load Chain_Sampled.mat Chain_Sampled
% Chain = Chain_Sampled;
% Chain = topkrows(Chain,1,'descend');
% Chain = IncreaseKmax(Chain, Kmax);
% [xzc, rhoc, susc] = Chian2xz(Chain);
% [identity, kcell] = Identify(xzc(1,1:3),xzc(2,1:3),xzc(1,4:end),xzc(2,4:end));
% [rhoc,susc] = identity2rhosuc(identity);



[DensityMap, SusMap] = xz2model(xzc(1,:),xzc(2,:),rhoc,susc);

[rg, rT] = ForwardModel(DensityMap, SusMap);

Cov_g = rg2Cov_g(rg);
Cov_T = rT2Cov_T(rT);
PLOT_COV_MATRIX(C_original_grv,C_original_rtp,Cov_g, Cov_T,fpath,'C_Initial',[]);

Xigc = 1;
XiTc = 1;
LogLc = Log_Likelihood(rg,Cov_g,Xigc,rT,Cov_T,XiTc);
Chain(1,1:4+numel(xzc)+numel(rhoc)+numel(susc))=[LogLc size(xzc,2) Xigc XiTc reshape(xzc',1,numel(xzc)) rhoc susc];
Chain=repelem(Chain(1,:),Nchain,1);

pause('on')
PLOT_CHAINS_Density(Chain,fpath,'ChainDensity_Initial',[]);
pause(5)
PLOT_CHAINS_Sus(Chain,fpath,'ChainSus_Initial',[]);
pause(5)
PLOT_BestChain_Density(Chain,fpath,'MaxLDensity_Initial',[]);
pause(5)
PLOT_BestChain_Sus(Chain,fpath,'MaxLSus_Initial',[]);
end