function PLOT_COV_MATRIX(C_original_grv,C_original_rtp,Cov_g_maxL, Cov_T_maxL ,fpath,figname,fignum)
global damp_dg damp_dT ExportEPSFig
Cg_maxL = reshape(Cov_g_maxL',size(damp_dg));
CT_maxL = reshape(Cov_T_maxL',size(damp_dT));
row = ceil(size(damp_dg,1)/2);
figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
subplot(2,3,1)
plot(sqrt(diag(C_original_grv)),'r--','linewidth',2),hold on,plot(sqrt(diag(Cg_maxL)),'k-','linewidth',2),ylabel('STD (mGal)'),xlabel('index'),set(gca,'fontsize',12,'fontweight','bold')
subplot(2,3,2)
plot(C_original_grv(row,:),'r--','linewidth',2),hold on,plot(Cg_maxL(row,:),'k-','linewidth',2),ylabel('Covariance (mGal^{2})'),xlabel('lag'),set(gca,'fontsize',12,'fontweight','bold')
subplot(2,3,3)
imagesc(Cg_maxL),colorbar,axis on,ylabel('lag'),xlabel('lag'),set(gca,'fontsize',12,'fontweight','bold'),cbar=colorbar;axis square
cbar.Label.String = 'Covariance (mGal^{2})';

subplot(2,3,4)
plot(sqrt(diag(C_original_rtp)),'r--','linewidth',2),hold on,plot(sqrt(diag(CT_maxL)),'k-','linewidth',2),ylabel('STD (nT)'),xlabel('index'),set(gca,'fontsize',12,'fontweight','bold')
subplot(2,3,5)
plot(C_original_rtp(row,:),'r--','linewidth',2),hold on,plot(CT_maxL(row,:),'k-','linewidth',2),ylabel('Covariance (nT^{2})'),xlabel('lag'),set(gca,'fontsize',12,'fontweight','bold')
subplot(2,3,6)
imagesc(CT_maxL),colorbar,axis on,ylabel('lag'),xlabel('lag'),set(gca,'fontsize',12,'fontweight','bold'),cbar=colorbar;axis square
cbar.Label.String = 'Covariance (nT^{2})';

drawnow
% saveas(gca, fullfile(fpath, strcat('C_',num2str(k))), 'png');
set(gcf,'color','w');
img = getframe(gcf);
imwrite(img.cdata, [fullfile(fpath,strcat(figname,num2str(fignum))), '.png']);
% Save eps Figure
if ExportEPSFig == 1
    figname= figname(find(~isspace(figname)));
    print(gcf,'-depsc2','-painters',fullfile(fpath,strcat(figname,num2str(fignum))));
end
end