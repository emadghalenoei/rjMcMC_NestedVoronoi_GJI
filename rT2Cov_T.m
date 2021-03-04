function Cov_T = rT2Cov_T(rT)
global  damp_dT  sigma_T_min Stationary Nonstationary Cor
if (Stationary == 1) && (Nonstationary == 0) && (Cor == 0)
    % use only at the initial inversion. Do not use xcov in this step
    % because xcov removes mean of residuals and it does not then minimized
    % the residuals.
    NT = length(rT);
    sigma_T = vecnorm(rT,2)/sqrt(NT);
    sigma_T(sigma_T<sigma_T_min)=sigma_T_min;
    Cov_T = sigma_T^2 .* eye(NT);
elseif (Stationary == 0) && (Nonstationary == 1)  && (Cor == 0)
    % use only at the initial inversion. Do not use xcov in this step
    % because xcov removes mean of residuals and it does not then minimized
    % the residuals.
    NT = length(rT);
    Q=floor(NT/5);
    sigma_T = sqrt(movmean(rT.^2,Q,'Endpoints','fill'));
    sigma_T = fillmissing(sigma_T,'nearest','EndValues','nearest');
    sigma_T(sigma_T<sigma_T_min)=sigma_T_min;
    Cov_T = diag(sigma_T.^2);
elseif  (Stationary == 1) && (Nonstationary == 0) && (Cor == 1)
    
    NT = length(rT);
    sigma_T = vecnorm(rT,2)/sqrt(NT);
    sigma_T(sigma_T<sigma_T_min)=sigma_T_min;
    S = sigma_T .* eye(NT);
    [c,lags] = xcov(rT,'coeff');
    c = c(lags>=0);
    R = toeplitz(c);
    Cov_T = S' * R *S;
    Cov_T = Cov_T.*damp_dT;
    
elseif (Stationary == 0) && (Nonstationary == 1) && (Cor == 1)
    Q=floor(length(rT)/5);
    sigma_T = sqrt(movmean(rT.^2,Q,'Endpoints','fill'));
    sigma_T = fillmissing(sigma_T,'nearest','EndValues','nearest');
    sigma_T(sigma_T<sigma_T_min)=sigma_T_min;
    S = diag(sigma_T);
    sr = rT./sigma_T;
    [c,lags] = xcov(sr,'coeff');
    c = c(lags>=0);
    R = toeplitz(c);
    Cov_T = S' * R *S;
    Cov_T = Cov_T.*damp_dT;
end
end