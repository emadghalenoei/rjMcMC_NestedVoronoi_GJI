function [Cov_g, Cov_T] = r2C(rg, rT)
global damp_dg damp_dT sigma_g_min sigma_T_min Stationary Nonstationary Cor
if (Stationary == 1) && (Nonstationary == 0) && (Cor == 0)
    Ng = length(rg);
    sigma_g = vecnorm(rg,2)/sqrt(Ng);
    sigma_g(sigma_g<sigma_g_min)=sigma_g_min;
    Cov_g = sigma_g^2 .* eye(Ng);
    
    NT = length(rT);
    sigma_T = vecnorm(rT,2)/sqrt(NT);
    sigma_T(sigma_T<sigma_T_min)=sigma_T_min;
    Cov_T = sigma_T^2 .* eye(NT);
elseif (Stationary == 0) && (Nonstationary == 1)  && (Cor == 0)
    Ng = length(rg);
    Q=floor(Ng/5);
    sigma_g = sqrt(movmean(rg.^2,Q,'Endpoints','fill'));
    sigma_g = fillmissing(sigma_g,'nearest','EndValues','nearest');
    sigma_g(sigma_g<sigma_g_min)=sigma_g_min;
    Cov_g = diag(sigma_g.^2);
    
    NT = length(rT);
    Q=floor(NT/5);
    sigma_T = sqrt(movmean(rT.^2,Q,'Endpoints','fill'));
    sigma_T = fillmissing(sigma_T,'nearest','EndValues','nearest');
    sigma_T(sigma_T<sigma_T_min)=sigma_T_min;
    Cov_T = diag(sigma_T.^2);
elseif  (Stationary == 1) && (Nonstationary == 0) && (Cor == 1)
    Ng = length(rg);
    sigma_g = vecnorm(rg,2)/sqrt(Ng);
    sigma_g(sigma_g<sigma_g_min)=sigma_g_min;
    S = sigma_g .* eye(Ng);
    sr = rg./sigma_g;
    [c,lags] = xcov(sr,'biased');
    c = c(lags>=0);
    R = toeplitz(c);
    Cov_g = S' * R *S;
    Cov_g = Cov_g.*damp_dg;
    
    NT = length(rT);
    sigma_T = vecnorm(rT,2)/sqrt(NT);
    sigma_T(sigma_T<sigma_T_min)=sigma_T_min;
    S = sigma_T .* eye(NT);
    sr = rT./sigma_T;
    [c,lags] = xcov(sr,'biased');
    c = c(lags>=0);
    R = toeplitz(c);
    Cov_T = S' * R *S;
    Cov_T = Cov_T.*damp_dT;
    
elseif (Stationary == 0) && (Nonstationary == 1) && (Cor == 1)
    Q=floor(length(rg)/5);
    sigma_g = sqrt(movmean(rg.^2,Q,'Endpoints','fill'));
    sigma_g = fillmissing(sigma_g,'nearest','EndValues','nearest');
    sigma_g(sigma_g<sigma_g_min)=sigma_g_min;
    S = diag(sigma_g);
    sr = rg./sigma_g;
    [c,lags] = xcov(sr,'biased');
    c = c(lags>=0);
    R = toeplitz(c);
    Cov_g = S' * R *S;
    Cov_g = Cov_g.*damp_dg;
    
    Q=floor(length(rT)/5);
    sigma_T = sqrt(movmean(rT.^2,Q,'Endpoints','fill'));
    sigma_T = fillmissing(sigma_T,'nearest','EndValues','nearest');
    sigma_T(sigma_T<sigma_T_min)=sigma_T_min;
    S = diag(sigma_T);
    sr = rT./sigma_T;
    [c,lags] = xcov(sr,'biased');
    c = c(lags>=0);
    R = toeplitz(c);
    Cov_T = S' * R *S;
    Cov_T = Cov_T.*damp_dT;
end
end