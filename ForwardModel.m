function [rg, rT] = ForwardModel(model_g, model_T)
global Kernel_Grv dg_obs dT_obs Kernel_Mag 
dg_pre = (Kernel_Grv*model_g(:)).*1e8; % Unit(mGal)
rg = dg_obs-dg_pre;

dT_pre = Kernel_Mag*model_T(:); %(nT)
rT = dT_obs-dT_pre;
end