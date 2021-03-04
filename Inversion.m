function Chain = Inversion(Chain,Temp,Nupdate,NMCMC,name)
global fpath C_original_grv  C_original_rtp  Kmax acpt_counter acpt_total swap_counter swap_total applyUpdate
Nchain = size(Chain,1);
Cov_str = strcat('C',name);
ChainG_str = strcat('ChainDensity',name);
ChainT_str = strcat('ChainSus',name);
MaxLG_str = strcat('MaxLG',name);
MaxLT_str = strcat('MaxLT',name);
Data_str = strcat('Data',name);
Swap_str = strcat('Swap',name);
% Accpt_str = strcat('Accpt',name);
for iupdate = 1:Nupdate
    
%     Chain = ChainDuplicate(Chain,Nchain); % very important to investigate lator please
    
    Chain(:,3) = 1; % Xi =1
    Chain(:,4) = 1; % Xi =1
    [Cov_g, Cov_T] = Update_C(Chain);
    PLOT_COV_MATRIX(C_original_grv,C_original_rtp,Cov_g, Cov_T,fpath,Cov_str,iupdate);
    if applyUpdate == 1
        Chain = Update_LogL(Chain,Cov_g, Cov_T);
    end
    acpt_counter = zeros(2+ Kmax*4-6, Kmax, Nchain);
    acpt_total = zeros(2+ Kmax*4-6, Kmax, Nchain);
    swap_counter = zeros(Nchain, Nchain);
    swap_total = zeros(Nchain, Nchain);
    for imcmc=1:NMCMC
        
        for ichain=1:Nchain
            Chain(ichain,:) = RJMCMC(Chain(ichain,:),Temp(ichain),Cov_g,Cov_T,ichain,imcmc);
        end
        for ichain=1:Nchain
            Chain = TEMPSWAP(Temp,Chain);
        end
    end
    close all
    pause('on')
    PLOT_CHAINS_Density(Chain,fpath,ChainG_str,iupdate)
    pause(5)
    PLOT_CHAINS_Sus(Chain,fpath,ChainT_str,iupdate)
    pause(5)
    PLOT_BestChain_Density(Chain,fpath,MaxLG_str,iupdate)
    pause(5)
    PLOT_BestChain_Sus(Chain,fpath,MaxLT_str,iupdate)
    pause(5)
    PLOT_BestData(Chain,fpath,Data_str,iupdate)
    pause(5)
    swap_rate = swap_counter./ swap_total;
    swap_rate(isnan(swap_rate))=0;
    PLOT_swap_rate(swap_rate,Temp,fpath,Swap_str,iupdate);
    pause(5)
%      acpt_ratio = acpt_counter./acpt_total; acpt_ratio(isnan(acpt_ratio))=0;
%     PLOT_accpt_rate(acpt_ratio,fpath,Accpt_str,iupdate);
    save('Chain.mat','Chain');  
end
end