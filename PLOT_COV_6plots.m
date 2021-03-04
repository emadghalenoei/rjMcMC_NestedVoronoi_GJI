function PLOT_COV_6plots(C_original_grv,C_original_rtp,Cov_g_maxL, Cov_T_maxL ,fpath,figname,fignum)
global damp_dg damp_dT ExportEPSFig
Cg_maxL = reshape(Cov_g_maxL',size(damp_dg));
CT_maxL = reshape(Cov_T_maxL',size(damp_dT));
row = ceil(size(damp_dg,1)/2);
figure('units','normalized','outerposition',[0 0 1 1],'visible','on');
left = 0.1;
bottom = 0.55;
width = 0.2;
height = 0.35;
dw = 0.02; % between subplots
dh = 0.02; % between subplots
pos1 = [left bottom width height];
h1=subplot('Position',pos1);

plot(sqrt(diag(C_original_grv)),'r--','linewidth',2),hold on,plot(sqrt(diag(Cg_maxL)),'k-','linewidth',2),ylabel('STD (mGal)'),set(gca,'fontsize',12,'fontweight','bold')
xticklabels(h1,[]);
title('(a)')

pos2 = [left bottom-0.38 width height];
h2 = subplot('Position',pos2);
plot(sqrt(diag(C_original_rtp)),'r--','linewidth',2),hold on,plot(sqrt(diag(CT_maxL)),'k-','linewidth',2),ylabel('STD (nT)'),xlabel('index'),set(gca,'fontsize',12,'fontweight','bold')
title('(b)')


left = 0.38;
bottom = 0.55;
width = 0.2;
height = 0.35;
dw = 0.02; % between subplots
dh = 0.02; % between subplots
pos3 = [left bottom width height];
h3=subplot('Position',pos3);
plot(C_original_grv(row,:),'r--','linewidth',2),hold on,plot(Cg_maxL(row,:),'k-','linewidth',2),ylabel('Covariance (mGal^{2})'),set(gca,'fontsize',12,'fontweight','bold')
xticklabels(h3,[]);
title('(c)')

pos4 = [left bottom-0.38 width height];
h4=subplot('Position',pos4);
plot(C_original_rtp(row,:),'r--','linewidth',2),hold on,plot(CT_maxL(row,:),'k-','linewidth',2),xlabel('lag'),ylabel('Covariance (nT^{2})'),set(gca,'fontsize',12,'fontweight','bold')
h4.YAxis.Exponent = 0;
title('(d)')

left = 0.65;
bottom = 0.55;
width = 0.27;
height = 0.35;
dw = 0.02; % between subplots
dh = 0.02; % between subplots
pos5 = [left bottom width height];
h5=subplot('Position',pos5);
imagesc(Cg_maxL),colorbar,axis on,ylabel('lag'),set(gca,'fontsize',12,'fontweight','bold'),cbar=colorbar;
cbar.Label.String = 'Covariance (mGal^{2})';
xticklabels(h5,[]);
title('(e)')

pos6 = [left bottom-0.38 width height];
h6=subplot('Position',pos6);
imagesc(CT_maxL),colorbar,axis on,ylabel('lag'),xlabel('lag'),set(gca,'fontsize',12,'fontweight','bold'),cbar=colorbar;
cbar.Label.String = 'Covariance (nT^{2})';
cbar.Ruler.Exponent = 0;
title('(f)')
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