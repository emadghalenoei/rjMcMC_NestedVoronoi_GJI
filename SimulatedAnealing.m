function Chain = SimulatedAnealing(Chain,Nchain,T_SA,Nupdate,NMCMC,name)
global fpath    C_original_grv C_original_rtp acpt_counter acpt_total swap_counter swap_total Kmax
Cov_str = strcat('C',name);
Chain_str = strcat('Chain',name);
MaxL_str = strcat('MaxL',name);
Data_str = strcat('Data',name);

acpt_counter = zeros(Kmax*2 + 5, Kmax, Nupdate);
acpt_total = zeros(Kmax*2 + 5, Kmax, Nupdate);
swap_counter = zeros(Nupdate, Nupdate);
swap_total = zeros(Nupdate, Nupdate);

Temp = logspace(log10(T_SA),0,Nupdate);
for iupdate=1:Nupdate
    [Cov_g, Cov_T] = Update_C(Chain);
    PLOT_COV_MATRIX(C_original_grv,C_original_rtp,Cov_g, Cov_T,fpath,Cov_str,iupdate);
    for imcmc=1:NMCMC
        Chain(1,:) = RJMCMC(Chain(1,:),Temp(iupdate),Cov_g,Cov_T,iupdate,imcmc);
    end
    close all
    Chain=repelem(Chain(1,:),Nchain,1);
    PLOT_CHAINS(Chain,fpath,Chain_str,iupdate)
    PLOT_BestChain(Chain,fpath,MaxL_str,iupdate)
    PLOT_BestData(Chain,fpath,Data_str,iupdate)
    save('Chain.mat','Chain');
end