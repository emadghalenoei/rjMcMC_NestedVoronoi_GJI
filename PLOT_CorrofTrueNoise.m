function PLOT_CorrofTrueNoise(noise_g_original,noise_T_original,R_g_original,R_T_original,fpath,figname,fignum)
figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
subplot(1,2,1)
[cg,lags] = xcov(noise_g_original,'biased');
cg = cg./cg(lags==0);
plot(lags(lags>=0), cg(lags>=0),'k--','LineWidth',2);
hold on
plot(lags(lags>=0),R_g_original(1,:),'b','LineWidth',2);
ylabel('autocorrelation (Gravity)')
xlabel('lag')
set(gca,'fontsize',10,'fontweight','bold')



subplot(1,2,2)
[cT,lags] = xcov(noise_T_original,'biased');
cT = cT./cT(lags==0);
plot(lags(lags>=0), cT(lags>=0),'k--','LineWidth',2);
hold on
plot(lags(lags>=0),R_T_original(1,:),'b','LineWidth',2);
ylabel('autocorrelation (Magnetic)')
xlabel('lag')
set(gca,'fontsize',10,'fontweight','bold')

set(gcf,'color','w');
img = getframe(gcf);
imwrite(img.cdata, [fullfile(fpath,strcat(figname,num2str(fignum))), '.png']);
end