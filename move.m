function [LogLc,xzc,rhoc,susc,rgc,rTc] = move(LogLc,xzc,rhoc,susc,Xigc,XiTc,T,ichain,Cov_g,Cov_T)
global  acpt_counter acpt_total  applyXi applyUpdate z_min_voronoi  rho_basement_min rho_basement_max
global sus_basement_min sus_basement_max  drho_basement drho_salt  dsus_basement   rho_salt_min rho_salt_max

[DensityMap, SusMap] = xz2model(xzc(1,:),xzc(2,:),rhoc,susc);
[rgc, rTc] = ForwardModel(DensityMap, SusMap);
Nnode=size(xzc,2);
xstepsize = 0.01 *ones(1,Nnode);
zstepsize = 0.01 *ones(1,Nnode);
stepsize = [xstepsize, zstepsize];
rhostepsize_salt = drho_salt/5;
rhostepsize_basement = drho_basement/5;
susstepsize_basement = dsus_basement/5;
minlim = [zeros(1,Nnode), z_min_voronoi*ones(1,Nnode)];
maxlim = ones(1, 2*Nnode);
Npar = 4*Nnode-6;
for ipar = 1:Npar
    rhop = rhoc;
    susp =susc;
    xzp  = xzc;
    
    if ipar <=2*Nnode
        mc = [xzc(1,:), xzc(2,:)];
        mp =mc;
        mp(ipar) = cauchy_dist(mc(ipar),stepsize(ipar),[1,1],minlim(ipar),maxlim(ipar),mc(ipar));
        xzp = reshape(mp,size(xzc'))';
        
        [identity_c, kcell] = Identify(xzc(1,1:3),xzc(2,1:3),xzc(1,4:end),xzc(2,4:end));
        [identity_p, kcell] = Identify(xzp(1,1:3),xzp(2,1:3),xzp(1,4:end),xzp(2,4:end));
        idendiff = identity_p - identity_c;
        coeff = double(logical(idendiff));
        if sum(coeff)~=0
            [rhop,susp] = identity2rhosuc(identity_p);
            rhop = ((1-coeff).*rhoc) + (coeff .* rhop);
            susp = ((1-coeff).*susc) + (coeff .* susp);
        end
        
        % Density
    elseif ipar >2*Nnode && ipar <= 3*Nnode-3
        if ipar == 2*Nnode+1
            [identity_c, kcell] = Identify(xzc(1,1:3),xzc(2,1:3),xzc(1,4:end),xzc(2,4:end));
        end
        if identity_c(ipar-2*Nnode) == 1
            % Do Nothing
        elseif identity_c(ipar-2*Nnode) == 2
            rhop(ipar-2*Nnode) = cauchy_dist(rhoc(ipar-2*Nnode),rhostepsize_salt, [1,1],rho_salt_min,rho_salt_max,rhoc(ipar-2*Nnode));
        elseif identity_c(ipar-2*Nnode) == 3
            rhop(ipar-2*Nnode) = cauchy_dist(rhoc(ipar-2*Nnode),rhostepsize_basement, [1,1],rho_basement_min,rho_basement_max,rhoc(ipar-2*Nnode));
        end
        
        
        %SUS
    elseif ipar >3*Nnode-3 && ipar <= Npar
        if identity_c(ipar-3*Nnode+3) == 1
            % Do Nothing
        elseif identity_c(ipar-3*Nnode+3) == 2
            % Do Nothing
        elseif identity_c(ipar-3*Nnode+3) == 3
            susp(ipar-3*Nnode+3) = cauchy_dist(susc(ipar-3*Nnode+3),susstepsize_basement, [1,1],sus_basement_min,sus_basement_max,susc(ipar-3*Nnode+3));
        end
    end
    
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
        rhoc = rhop;
        susc =susp;
        LogLc=LogLp;
        rgc = rg;
        rTc = rT;
        acpt_counter(ipar,Nnode,ichain) = acpt_counter(ipar,Nnode,ichain) + 1;
    end
end
acpt_total(1:Npar,Nnode,ichain) = acpt_total(1:Npar,Nnode,ichain) + 1;
end