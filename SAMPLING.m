function [timeOFsteps, Chain, mkeep] = SAMPLING(Chain,Temp,NMCMC,Cov_g,Cov_T,name)
global fpath    Kmax acpt_counter acpt_total swap_counter swap_total
Nchain = size(Chain,1);
ChainG_str = strcat('ChainDensity',name);
ChainT_str = strcat('ChainSus',name);
MaxLG_str = strcat('MaxLG',name);
MaxLT_str = strcat('MaxLT',name);
Data_str = strcat('Data',name);
Swap_str = strcat('Swap',name);
Accpt_str = strcat('Accpt',name);
LogL_str = strcat('LogL',name);

acpt_counter = zeros(2+ Kmax*4-6, Kmax, Nchain);
acpt_total = zeros(2+ Kmax*4-6, Kmax, Nchain);
swap_counter = zeros(Nchain, Nchain);
swap_total = zeros(Nchain, Nchain);

mkeep = zeros(NMCMC*sum(Temp == 1),size(Chain,2));
timeOFsteps = zeros(1,NMCMC*sum(Temp == 1));
tic
for imcmc=1:NMCMC
    for ichain=1:Nchain
        Chain(ichain,:) =  RJMCMC(Chain(ichain,:),Temp(ichain),Cov_g,Cov_T,ichain,imcmc);
    end
    mkeep((imcmc-1)*sum(Temp == 1)+1:imcmc*sum(Temp == 1),:) = Chain(Temp==1,:);
    timeOFsteps(1,(imcmc-1)*sum(Temp == 1)+1:imcmc*sum(Temp == 1))=toc;
    if rem(imcmc,4000)==0
        close all
        pause('on')
%         PLOT_CHAINS_Density(Chain,fpath,ChainG_str,imcmc)
%         pause(5)
%         PLOT_CHAINS_Sus(Chain,fpath,ChainT_str,imcmc)
%         pause(5)
        PLOT_BestChain_Density(Chain,fpath,MaxLG_str,imcmc)
        pause(5)
        PLOT_BestChain_Sus(Chain,fpath,MaxLT_str,imcmc)
        pause(5)
        PLOT_BestData(Chain,fpath,Data_str,imcmc)
        pause(5)
        swap_rate = swap_counter./ swap_total;
        swap_rate(isnan(swap_rate))=0;
        PLOT_swap_rate(swap_rate,Temp,fpath,Swap_str,imcmc);
        pause(5)
%         acpt_ratio = acpt_counter./acpt_total; acpt_ratio(isnan(acpt_ratio))=0;
%         PLOT_accpt_rate(acpt_ratio,fpath,Accpt_str,imcmc);
        save('Chain.mat','Chain');
        pause(5)
        save('mkeep.mat','mkeep');
        pause(5)
        save('timeOFsteps.mat','timeOFsteps');
        pause(5)
        LOGL = mkeep(1:imcmc*sum(Temp == 1),1);
        NumofNode = mkeep(1:imcmc*sum(Temp == 1),2);
        ElapsedTime = timeOFsteps(1:imcmc*sum(Temp == 1));
        PLOT_LOGL(ElapsedTime,LOGL,NumofNode,fpath,LogL_str,imcmc); % Plot LogL
    end
    for ichain=1:Nchain
        Chain=TEMPSWAP(Temp,Chain);
    end
end
end