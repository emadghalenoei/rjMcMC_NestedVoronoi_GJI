function Cov_g = rg2Cov_g(rg)
global damp_dg  sigma_g_min Stationary Nonstationary Cor
if (Stationary == 1) && (Nonstationary == 0) && (Cor == 0)
    % use only at the initial inversion. Do not use xcov in this step
    % because xcov removes mean of residuals and it does not then minimized
    % the residuals.
    Ng = length(rg);
    sigma_g = vecnorm(rg,2)/sqrt(Ng);
    sigma_g(sigma_g<sigma_g_min)=sigma_g_min;
    Cov_g = sigma_g^2 .* eye(Ng);
    
elseif (Stationary == 0) && (Nonstationary == 1)  && (Cor == 0)
    % use only at the initial inversion. Do not use xcov in this step
    % because xcov removes mean of residuals and it does not then minimized
    % the residuals.
    Ng = length(rg);
    Q=floor(Ng/5);
    sigma_g = sqrt(movmean(rg.^2,Q,'Endpoints','fill'));
    sigma_g = fillmissing(sigma_g,'nearest','EndValues','nearest');
    sigma_g(sigma_g<sigma_g_min)=sigma_g_min;
    Cov_g = diag(sigma_g.^2);
    
elseif  (Stationary == 1) && (Nonstationary == 0) && (Cor == 1)
    Ng = length(rg);
    sigma_g = vecnorm(rg,2)/sqrt(Ng);
    sigma_g(sigma_g<sigma_g_min)=sigma_g_min;
    S = sigma_g .* eye(Ng);
    [c,lags] = xcov(rg,'coeff');
    c = c(lags>=0);
    R = toeplitz(c);
    Cov_g = S' * R *S;
    Cov_g = Cov_g.*damp_dg;
   
elseif (Stationary == 0) && (Nonstationary == 1) && (Cor == 1)
    Q=floor(length(rg)/5);
    sigma_g = sqrt(movmean(rg.^2,Q,'Endpoints','fill'));
    sigma_g = fillmissing(sigma_g,'nearest','EndValues','nearest');
    sigma_g(sigma_g<sigma_g_min)=sigma_g_min;
    S = diag(sigma_g);
    sr = rg./sigma_g;
    [c,lags] = xcov(sr,'coeff');
    c = c(lags>=0);
    R = toeplitz(c);
    Cov_g = S' * R *S;
    Cov_g = Cov_g.*damp_dg;
end
end