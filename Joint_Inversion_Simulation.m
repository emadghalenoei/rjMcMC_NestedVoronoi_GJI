% FuncName - Joint inversion of grv/mag data

% this MATLAB code performs rjMcMC algorithm to invert gravity and magnetic
% data to image the subsurface models. more info can be found at my journal
% paper.
% descibing inputs, processing and outputs
% inputs: two text files: GRV_Profile.txt and 'RTP_Profile.txt
% Each text file has three columns including [X Y observation]
% it will create a folder 'Image' in the current path for the outputs

% Emad Ghalenoei, Univesity of Calgary, March 2021
%
% See also TheOtherFunction.
% Copyright: This is published under GJI manuscript entitled "Gravity and Magnetic Joint Inversion to 
                                   ... Resolve Basement and Salt Structures with Reversible-Jump Algorithm"
% You are allowed to use, as long as you cite this work.
https://doi.org/10.1093/gji/ggab251


clc
clear all
close all
format long g

global Kernel_Grv dg_obs dT_obs  xs_dg ys_dg xs_dT ys_dT Xn Zn x_min x_max z_min z_max Kmin Kmax dx dz damp_dg damp_dT 
global swap_counter swap_total  acpt_counter  acpt_total  Xi_min Xi_max sigma_g_min sigma_T_min X Z Stationary Nonstationary
global   Kernel_Mag  y_min y_max  Cor  fpath drho_salt sus_salt_min sus_salt_max drho_basement drho_salt dsus_basement
global True_LOGL C_original_grv  C_original_rtp   applyXi dg_true dT_true ExportEPSFig dis_dg dis_dT dis_min dis_max
global applyUpdate DISMODEL  z_min_voronoi rho_salt_min rho_salt_max rho_basement_min rho_basement_max sus_basement_min sus_basement_max


ExportEPSFig = 0;

foldername='Image';
fpath = strcat(pwd,'\',foldername);
mkdir(foldername);
rmdir(fpath, 's');
mkdir(foldername);

Gravity_Data = load('GRV_Profile.txt');
Magnetic_Data = load('RTP_Profile.txt');

DIS_GRV = sqrt((Gravity_Data(:,1)-Gravity_Data(1,1)).^2 + (Gravity_Data(:,2)-Gravity_Data(1,2)).^2);
DIS_MAG = sqrt((Magnetic_Data(:,1)-Magnetic_Data(1,1)).^2 + (Magnetic_Data(:,2)-Magnetic_Data(1,2)).^2);

Npoints_grv = 30;
Npoints_rtp = 30;
xs_dg = linspace(Gravity_Data(1,1),Gravity_Data(end,1),Npoints_grv);
ys_dg = linspace(Gravity_Data(1,2),Gravity_Data(end,2),Npoints_grv);
dis_dg = sqrt((xs_dg-xs_dg(1,1)).^2 + (ys_dg-ys_dg(1,1)).^2);
dg_obs = interpn(DIS_GRV,Gravity_Data(:,3),dis_dg,'spline');

xs_dT = linspace(Magnetic_Data(1,1),Magnetic_Data(end,1),Npoints_rtp);
ys_dT = linspace(Magnetic_Data(1,2),Magnetic_Data(end,2),Npoints_rtp);
dis_dT = sqrt((xs_dT-xs_dT(1,1)).^2 + (ys_dT-ys_dT(1,1)).^2);
dT_obs = interpn(DIS_MAG,Magnetic_Data(:,3),dis_dT,'spline');

%model space
Z0 = 0;            %km
ZEND = 10000;      %km
dZ = 100;          %km
Pad_Length = 6000; %km
[DISMODEL,X,Y,Z] = ModelSpace(xs_dg,ys_dg,Z0,ZEND,dZ,Pad_Length);
dx=abs(X(1,2)-X(1,1));
dy=abs(Y(1,2)-Y(1,1));
dz=abs(Z(2,1)-Z(1,1));
dDis = abs(DISMODEL(1,2)-DISMODEL(1,1));


dg_obs = dg_obs';
dT_obs = dT_obs';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gravity Kernel with padding
Kernel_Grv = Gravity_Kernel_Expanded(DISMODEL,Z,dis_dg);

I = 90;           % inclination
Fe = 43314; %(nT) % Field magnetic intensity
Azimuth = atan2(xs_dT(end)-xs_dT(1),ys_dT(end)-ys_dT(1)); % Azimuth of profile line
Azimuth = Azimuth *180/pi;

% Magnetic Kernel with padding
Kernel_Mag = Mag_Kernel_Expanded(DISMODEL,Z,dis_dg,I,Azimuth);
Kernel_Mag = 2*Fe* Kernel_Mag;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% damping (used to damp the covarinace matrix and avoids instability)

ind=0:1:length(dg_obs)-1;
Dij=toeplitz(ind);
damp_dg = (cos((pi.*Dij)./(2*(length(dg_obs)-1)))).^ 1.5;
ind=0:1:length(dT_obs)-1;
Dij=toeplitz(ind);
damp_dT = (cos((pi.*Dij)./(2*(length(dT_obs)-1)))).^ 1.5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% defining true models
[TrueDensityModel, TrueSUSModel] = Model_Making();

% load true models from txt files
% TrueDensityModel = load('TrueDensityModel.txt');
% TrueSUSModel = load('TrueSUSModel.txt');

% compute true data
dg_true = (Kernel_Grv*TrueDensityModel(:)).*1e8; % Unit(mGal)
dT_true= Kernel_Mag*TrueSUSModel(:); %(nT)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Adding correlated noise
noise_g_level = 0.04*ones(size(dg_true));
dg_hat=abs(dg_true);
dg_hat(abs(dg_true)<0.1)=0.1;
sigma_g_original=noise_g_level.*max(abs(dg_hat));
% sigma_g_original=noise_g_level.*(abs(dg_hat));
ind=0:1:length(dg_true)-1;
Dij=toeplitz(ind);
re1=5; % lower this number leads to converging to 0 at right side of function
L1=5; % it brings the function into lower number (vertically), higher L1, upper number, less waves
R_g_original=exp(-Dij./re1).*cos(2*pi.*Dij./L1);
S_g_original=diag(sigma_g_original);
C_original_grv=S_g_original' * R_g_original * S_g_original;
C_original_grv=C_original_grv.*damp_dg;
np = normrnd(0,1,size(dg_true));
L_g_original = chol(C_original_grv,'lower');
noise_g_original=L_g_original*np;
dg_obs=dg_true+noise_g_original;

noise_T_level = 0.01*ones(size(dT_true));
dT_hat=abs(dT_true);
dT_hat(abs(dT_hat)<0.1)=0.1;
sigma_T_original=noise_T_level.*max(abs(dT_hat));

S_T_original=diag(sigma_T_original);
R_T_original = R_g_original;
C_original_rtp=S_T_original' * R_T_original * S_T_original;
C_original_rtp=C_original_rtp.*damp_dT;
np = normrnd(0,1,size(dT_true));
L_T_original = chol(C_original_rtp,'lower');
noise_T_original=L_T_original*np;
dT_obs=dT_true+noise_T_original;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Inversion

% initializing
x_min=min(min(X))-dx/2;
x_max=max(max(X))+dx/2;
y_min=min(min(Y))-dy/2;
y_max=max(max(Y))+dy/2;
z_min=min(min(Z))-dz/2;
% z_min=4000;
z_max=max(max(Z))+dz/2;
dis_min = min(min(DISMODEL))-dDis/2; 
dis_max = max(max(DISMODEL))+dDis/2; 
Xn = (DISMODEL-dis_min)./(dis_max-dis_min);
Zn = (Z-z_min)./(z_max-z_min);

% No Voronoi nodes shallower than 3 km
z_min_voronoi=3000/z_max;

rho_salt_min = -0.4;
rho_salt_max = -0.03;
drho_salt = abs(rho_salt_max-rho_salt_min);

rho_basement_min = 0.1;
rho_basement_max = 0.5;
drho_basement = abs(rho_basement_max-rho_basement_min);

sus_basement_min = 0.004;
sus_basement_max = 0.008;
dsus_basement = abs(sus_basement_max-sus_basement_min);

sus_salt_min = 0;
sus_salt_max = 0;

sigma_g_min = 0.1; % measurement error (mGal)
sigma_T_min = 0.1; % measurement error (nT)

Xi_min = 1;
Xi_max = 40;

ExportEPSFig = 1;
PLOT_2DImage(DISMODEL(1,:),Z(:,1),TrueDensityModel,fpath,[rho_salt_min rho_basement_max],'bluewhitered','True Density model (gr/cm^{3})',[]); % Plot PMD of Model
PLOT_2DImage(DISMODEL(1,:),Z(:,1),TrueSUSModel,fpath,[0 sus_basement_max],'jet','True SUS model (SI)',[]); % Plot PMD of Model

ExportEPSFig = 0;
PLOT_ObservedData(fpath,'obs',[]);
PLOT_COV_MATRIX(C_original_grv,C_original_rtp,C_original_grv, C_original_rtp,fpath,'Orginal_Cov',[]);
PLOT_CorrofTrueNoise(noise_g_original,noise_T_original,R_g_original,R_T_original,fpath,'AutoCorrelation',[]);

True_LOGL= Log_Likelihood(noise_g_original,C_original_grv,1,noise_T_original,C_original_rtp,1);


Kmin=3+3; % kmin must be at least 6 because we have 3 mother nodes and should also have 3 additional nodes
Kmax=50;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initializing
Stationary = 1;
Nonstationary = 0;
Cor = 0;
applyXi = 0;
applyUpdate = 0;
Nchain = 12;  % number of chains
Chain = Initializing(Nchain);
Chain_start = Chain;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Simulated Anealing
% T_SA = 50;
% Nupdate = 20;
% NMCMC = 1000;
% Chain = SimulatedAnealing(Chain,Nchain,T_SA,Nupdate,NMCMC,'(SA)__');
% Chain_SA = Chain;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load Chain.mat Chain

% Kmax = 40;
% Chain = IncreaseKmax(Chain, Kmax);
% Chain = Chain_raw ;
% Chain = CDFresampling(Chain,Nchain);

Nchain = 12;                    % number of chains
NT1 = 4;                        % number of chains with T=1
dt = 1.2;                       % ratio between temperature levels
TempLevels=(Nchain-NT1):-1:1;   % define Temp Levels     
Temp=[(dt).^TempLevels ones(1,NT1)];

% Chain = ChainDuplicate(Chain,Nchain);
% Chain = CDFresampling(Chain,Nchain);

Stationary = 1;
Nonstationary = 0;
Cor = 0;
applyXi = 0;
applyUpdate = 0;
Nupdate = 50;
NMCMC = 2000;
Chain = Inversion(Chain,Temp,Nupdate,NMCMC,'(100v1)__');
Chain_raw = Chain;
save('Chain_raw.mat','Chain_raw') 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Chain = Chain_NST_raw;
% Chain = CDFresampling(Chain,Nchain);
% Nchain = 10;                    % number of chains
% NT1 = 5;                        % number of chains with T=1
% dt = 1.3;                       % ratio between temperature levels
% TempLevels=(Nchain-NT1):-1:1;   % define Temp Levels     
% Temp=[(dt).^TempLevels ones(1,NT1)];
% Stationary = 0;
% Nonstationary = 1;
% Cor = 0;
% Nupdate = 100;
% NMCMC = 3000;
% Chain = Inversion(Chain,Temp,Nupdate,NMCMC,'(010v2)__');
% Chain_NST_raw = Chain;
% save('Chain_NST_raw.mat','Chain_NST_raw') 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Chain = Chain_raw;
Nchain = 12;  % number of chains
NT1 = 4;       % number of chains with T=1
dt = 1.2;     % ratio between temperature levels
TempLevels=(Nchain-NT1):-1:1;   % define Temp Levels     
Temp=[(dt).^TempLevels ones(1,NT1)];
% Kmax = 40;
% Chain = IncreaseKmax(Chain, Kmax);
% Chain = CDFresampling(Chain,Nchain);

Stationary = 1;
Nonstationary = 0;
Cor = 1;
applyXi = 1;
applyUpdate = 1;
Nupdate = 10;
NMCMC = 1000;
Chain = Inversion(Chain,Temp,Nupdate,NMCMC,'(101)__');
Chain_C = Chain; % keep the chains with last updated C
save('Chain_C.mat','Chain_C')

ExportEPSFig = 0;
Chain = Chain_C;
[Cov_g, Cov_T] = Update_C(Chain_C);
PLOT_COV_MATRIX(C_original_grv,C_original_rtp,Cov_g, Cov_T,fpath,'C_sample',[]);
Chain = Update_LogL(Chain,Cov_g, Cov_T);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Before Sampling

Nchain = 12;  % number of chains
NT1 = 4;       % number of chains with T=1
dt = 1.2;     % ratio between temperature levels
TempLevels=(Nchain-NT1):-1:1;   % define Temp Levels     
Temp=[(dt).^TempLevels ones(1,NT1)];

Stationary = 1;
Nonstationary = 0;
Cor = 1;
applyUpdate = 0;
applyXi = 1;
ExportEPSFig = 0;
% Chain = ChainDuplicate(Chain,Nchain);
% Chain = CDFresampling(Chain,Nchain);

NMCMC = 20000;
[timeOFsteps, Chain, mkeep] = SAMPLING(Chain,Temp,NMCMC,Cov_g,Cov_T,'_Before_sample_v1_');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Sampling
% Chain = mkeep(end-Nchain-1:end,:);
% load Chain.mat Chain
% Chain = ChainDuplicate(Chain,Nchain);

Nchain = 12;  % number of chains
NT1 = 4;       % number of chains with T=1
dt = 1.2;     % ratio between temperature levels
TempLevels=(Nchain-NT1):-1:1;   % define Temp Levels     
Temp=[(dt).^TempLevels ones(1,NT1)];

Stationary = 1;
Nonstationary = 0;
Cor = 1;
applyUpdate = 0;
applyXi = 1;
ExportEPSFig = 0;
% Chain = ChainDuplicate(Chain,Nchain);
% Chain = CDFresampling(Chain,Nchain);

NMCMC = 200000;
[timeOFsteps, Chain, mkeep] = SAMPLING(Chain,Temp,NMCMC,Cov_g,Cov_T,'_sample_v1_');
Chain_Sampled = Chain;
save('Chain_Sampled.mat','Chain_Sampled');
save('mkeep.mat','mkeep');
save('timeOFsteps.mat','timeOFsteps');


% mkeep(1:20000,:) = [];
% timeOFsteps(1:20000) = [];
% timeOFsteps = timeOFsteps - timeOFsteps(1);


% %%%% Saving outputs
NSAMPLE = size(mkeep,1);
gridkeep_g = zeros(size(X,1)*size(X,2),NSAMPLE);
gridkeep_T = zeros(size(X,1)*size(X,2),NSAMPLE);
datakeep_dg=zeros(length(dg_obs),NSAMPLE);
datakeep_dT=zeros(length(dT_obs),NSAMPLE);
LogLikelihood=zeros(NSAMPLE,1);
NumofNode=zeros(NSAMPLE,1);
KCELL=zeros(NSAMPLE,3);
RHOkeep = nan(NSAMPLE,Kmax-3);
sigma_g=zeros(NSAMPLE,1);
sigma_T=zeros(NSAMPLE,1);
res_g=zeros(length(dg_obs),NSAMPLE);
res_T=zeros(length(dT_obs),NSAMPLE);
gridkeep_first = zeros(size(X,1),size(X,2));
gridkeep_last  = zeros(size(X,1),size(X,2));
first = 0;
last = 0;

for i=1:NSAMPLE
    LogLikelihood(i,1)=mkeep(i,1);
    NumofNode(i,1)=mkeep(i,2);
    [xz, rho, sus] = Chian2xz(mkeep(i,:));
    RHOkeep(i,1:NumofNode(i,1)-3) = mkeep(i,5+2*NumofNode(i,1):4+2*NumofNode(i,1)+size(xz,2)-3);
    [identity, KCELL(i,:)] = Identify(xz(1,1:3),xz(2,1:3),xz(1,4:end),xz(2,4:end));
    [gridi_g,gridi_T]= xz2model(xz(1,:),xz(2,:),rho, sus);
    [rg, rT] = ForwardModel(gridi_g,gridi_T);
    res_g(:,i) = rg;
    res_T(:,i) = rT;
    sigma_g(i,1) = vecnorm(rg,2)/sqrt(length(rg));
    sigma_T(i,1) = vecnorm(rT,2)/sqrt(length(rT));
    datakeep_dg(:,i) = dg_obs - rg;
    datakeep_dT(:,i) = dT_obs - rT;
    gridkeep_g(:,i) = gridi_g(:);
    gridkeep_T(:,i) = gridi_T(:);
    
    if i<= NSAMPLE/3
        first = first + 1;
        gridkeep_first = gridkeep_first + gridi_g;
    elseif i>=2*NSAMPLE/3 && i<= NSAMPLE
        last = last + 1;
        gridkeep_last = gridkeep_last + gridi_g;
    end
   
end


alpha = 0.05; % alpha: the code returns the 100(1 - alpha)% confidence intervals. For example, alpha = 0.05 yields 95% confidence intervals.

[data_mean_dg, data_CI_dg] = HPD_FAST(datakeep_dg,alpha); %HPD for gravity data

[data_mean_dT, data_CI_dT] = HPD_FAST(datakeep_dT,alpha); %HPD for magnetic data

PLOT_Joint_Data_CI(data_mean_dg, data_CI_dg,data_mean_dT, data_CI_dT,fpath,'Data_CI',[]) % Plot CI for Data

[PMD_total_g, CI_total_g] = HPD_FAST(gridkeep_g,alpha); %HPD for Density model

[PMD_total_T, CI_total_T] = HPD_FAST(gridkeep_T,alpha); %HPD for Susceptibility model

PMD_total_g = reshape(PMD_total_g,size(X));
CI_L_total_g = CI_total_g(:,1);
CI_L_total_g = reshape(CI_L_total_g,size(X));
CI_H_total_g = CI_total_g(:,2);
CI_H_total_g = reshape(CI_H_total_g,size(X));
CI_width_total_g = abs(CI_H_total_g-CI_L_total_g);

PMD_total_T = reshape(PMD_total_T,size(X));
CI_L_total_T = CI_total_T(:,1);
CI_L_total_T = reshape(CI_L_total_T,size(X));
CI_H_total_T = CI_total_T(:,2);
CI_H_total_T = reshape(CI_H_total_T,size(X));
CI_width_total_T = abs(CI_H_total_T-CI_L_total_T);

[PMD_first, CI_L_first, CI_H_first, CI_width_first] = HPD_Normal_approximation(gridkeep_first,first,alpha); % HPD for binary signals

[PMD_last, CI_L_last, CI_H_last, CI_width_last] = HPD_Normal_approximation(gridkeep_last,last,alpha); % HPD for binary signals



%%%% PLOT THE RESULTS
ExportEPSFig = 1;

PLOT_SigmaNoise(timeOFsteps,sigma_g,fpath,'Standard Deviation of Residuals (mGal)',[])

PLOT_SigmaNoise(timeOFsteps,sigma_T,fpath,'Standard Deviation of Residuals (nT)',[])

PLOT_LOGL(timeOFsteps,LogLikelihood,NumofNode,fpath,'LogL',[]); % Plot LogL

PLOT_TWOHIST(LogLikelihood,fpath,'LogLikelihood',[]);

PLOT_RHOHIST(RHOkeep,fpath,'RhoHist',[]);

PLOT_NumofNode(timeOFsteps,NumofNode,fpath,'NumofNode',[]); % Plot k

PLOT_KCELL(timeOFsteps,KCELL,fpath,'Kcell',[]); % Plot k inside each cell 1 2 3

% PLOT_TWOKCELL(timeOFsteps,KCELL,fpath,'TWOKcell',[]); % Plot k inside each cell 1 2 3

PLOT_JointSampledData(datakeep_dg,datakeep_dT,fpath,'Sampled_Data',[]) % Plot Predicted Data

PLOT_2DImage(DISMODEL(1,:),Z(:,1),PMD_total_g,fpath,[rho_salt_min rho_basement_max],'bluewhitered','Posterior Mean Density (gr/cm^{3})',[]); % Plot PMD of Density Model

PLOT_2DImage(DISMODEL(1,:),Z(:,1),PMD_total_T,fpath,[0 sus_basement_max],'jet','Posterior Mean Susceptibility (SI)',[]); % Plot PMD of Susceptibility Model

PLOT_3subplots(DISMODEL(1,:),Z(:,1),PMD_first,PMD_last,PMD_last-PMD_first,fpath,[rho_salt_min rho_basement_max],'bluewhitered','The First and last PMD',[]);


PLOT_2DImage(DISMODEL(1,:),Z(:,1),PMD_first,fpath,[rho_salt_min rho_basement_max],'bluewhitered','The First Posterior Mean Density (gr/cm^{3})',[]); % Plot PMD of the first Density Model

PLOT_2DImage(DISMODEL(1,:),Z(:,1),PMD_last,fpath,[rho_salt_min rho_basement_max],'bluewhitered','The Last Posterior Mean Density (gr/cm^{3})',[]); % Plot PMD of the last Density Model

PLOT_2DImage(DISMODEL(1,:),Z(:,1),PMD_last-PMD_first,fpath,[rho_salt_min rho_basement_max],'bluewhitered','Difference of Posterior Means (gr/cm^{3})',[]); % Plot Difference the last and the first

PLOT_Contour(DISMODEL(1,:),Z(:,1),PMD_total_g,-0.2,fpath,[rho_salt_min rho_basement_max],'bluewhitered','Contour on Posterior Mean (gr/cm^{3})',[]); % Plot Contour on PMD of Density Model

PLOT_2DImage(DISMODEL(1,:),Z(:,1),CI_width_total_g,fpath,[0 max(CI_width_total_g,[],'all')],'WhiteBlueGreenYellowRed','Density Credible Intervals Width (gr/cm^{3})',[]); % Plot CIs of Density Model

PLOT_2DImage(DISMODEL(1,:),Z(:,1),CI_width_total_T,fpath,[0 max(CI_width_total_T,[],'all')],'WhiteBlueGreenYellowRed','Susceptibility Credible Intervals Width (SI)',[]); % Plot CIs of Susceptibility Model

row = [70, 80, 95];
cul = [30, 51, 80];

PLOT_6subplots(DISMODEL(1,:),Z(:,1),TrueDensityModel,PMD_total_g,CI_width_total_g,TrueSUSModel,PMD_total_T,CI_width_total_T,fpath,[rho_salt_min rho_basement_max],'bluewhitered','The True and PMD',[]);


PLOT_7subplots(TrueDensityModel,PMD_total_g,CI_L_total_g,CI_H_total_g,TrueSUSModel,PMD_total_T,CI_L_total_T,CI_H_total_T,fpath,'all X Z lines',[]);

PLOT_ROW_MeanCIs(row,TrueDensityModel,PMD_total_g,CI_L_total_g,CI_H_total_g,fpath,[rho_salt_min-0.1 rho_basement_max+0.1],'Density (gr/cm^{3})',1);

PLOT_COL_MeanCIs(cul,TrueDensityModel,PMD_total_g,CI_L_total_g,CI_H_total_g,fpath,[rho_salt_min-0.1 rho_basement_max+0.1],'Density (gr/cm^{3})',2);

PLOT_ROWCOLonPMD(row,cul,DISMODEL(1,:),Z(:,1),PMD_total_g,fpath,[rho_salt_min rho_basement_max],'bluewhitered','Lines on Posterior Mean (gr/cm^{3})',[]);

row = [80, 85, 95];
cul = [30, 51, 80];

PLOT_ROW_MeanCIs(row,TrueSUSModel,PMD_total_T,CI_L_total_T,CI_H_total_T,fpath,[-2e-03 sus_basement_max],'Susceptibility (SI)',1);

PLOT_COL_MeanCIs(cul,TrueSUSModel,PMD_total_T,CI_L_total_T,CI_H_total_T,fpath,[-2e-03 sus_basement_max],'Susceptibility (SI)',2);

PLOT_ROWCOLonPMD(row,cul,DISMODEL(1,:),Z(:,1),PMD_total_T,fpath,[0 sus_basement_max],'jet','Lines on Posterior Mean (SI)',[]);


Chain_best = mkeep(mkeep(:,2)<=18,:);

Chain_best = topkrows(Chain_best,1,'descend');  % find chain with the highest LogL
PLOT_BestChain_Density(Chain_best,fpath,'Best_Model_Density',[]); % Plot chain with the highest LogL

PLOT_BestChain_Sus(Chain_best,fpath,'Best_Model_Sus',[]); % Plot chain with the highest LogL
Chain_best = topkrows(mkeep,1,'descend');  % find chain with the highest LogL

PLOT_BestChain_Density_and_Sus(Chain_best,fpath,'Best_Model',[]);

PLOT_ACF_Hist_residuals(res_g,res_T,Chain_raw,Cov_g,Cov_T,fpath);

PLOT_COV_6plots(C_original_grv,C_original_rtp,Cov_g, Cov_T,fpath,'Cov 6 final',[]);

% PLOT_raw_standardized_residuals(Chain_best,Chain_raw,Cov_g,Cov_T,fpath);  % Plot the autocorrelation and Histogram of standardized and raw residuals

% PLOT_Avg_residuals(res_g,res_T,Chain_raw,Cov_g,Cov_T,fpath);
% 
% PLOT_COV_MATRIX(C_original_grv,C_original_rtp,Cov_g, Cov_T,fpath,'C final',[]);

time=clock;
save(strcat('Joint_',num2str(time(1)),num2str(time(2)),num2str(time(3)),num2str(time(4)),num2str(time(5))));
