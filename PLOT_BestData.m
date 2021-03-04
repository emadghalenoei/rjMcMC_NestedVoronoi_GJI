function PLOT_BestData(Chain,fpath,figname,fignum)
global  dg_obs  dT_obs x_min x_max y_min y_max ExportEPSFig  dis_dg dis_min dis_max dis_dT
Chain_maxL = topkrows(Chain,1,'descend');
[xz, rho, sus] = Chian2xz(Chain_maxL);
[DensityMap, SusMap] = xz2model(xz(1,:),xz(2,:),rho, sus);
[rg, rT] = ForwardModel(DensityMap, SusMap);
dg_pre = dg_obs - rg;
dT_pre = dT_obs - rT;
figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
subplot(1,2,1)
plot(dis_dg,dg_obs,'k*-','LineWidth',2);
hold on
plot(dis_dg,dg_pre,'r--','LineWidth',2);
ylabel('Gravity (mGal)')
xlabel('X Profile (m)')
xlim([dis_min dis_max])
xtickangle(0)
ax1 = gca;
Xticks = round(linspace(dis_min,dis_max,6),2);
xticks(ax1,Xticks);
ax1.XAxis.Exponent = 0;
Xticks = round(linspace(x_min,x_max,6),2);
xticklabels(ax1,string(Xticks))
box(ax1,'off')
set(ax1,'fontsize',10,'fontweight','bold')
%%% the second axes
ax2=axes('Position',ax1.Position,'xlim', [dis_min, dis_max], 'color', 'none',...
    'YTick',[],'YColor','none','XColor','k', 'XAxisLocation', 'top');
Xticks = round(linspace(dis_min,dis_max,6),2);
xticks(ax2,Xticks);
ax2.XAxis.Exponent = 0;
Yticks = round(linspace(y_min,y_max,6),2);
xticklabels(ax2,string(Yticks))
set(ax2,'fontsize',10,'fontweight','bold')
xlabel(ax2,'Y Profile (m)','color','k');


subplot(1,2,2)
plot(dis_dT,dT_obs,'k*-','LineWidth',2);
hold on
plot(dis_dT,dT_pre,'r--','LineWidth',2);
ylabel('Gravity (mGal)')
xlabel('X Profile (m)')
xlim([dis_min dis_max])
xtickangle(0)
ax1 = gca;
Xticks = round(linspace(dis_min,dis_max,6),2);
xticks(ax1,Xticks);
ax1.XAxis.Exponent = 0;
Xticks = round(linspace(x_min,x_max,6),2);
xticklabels(ax1,string(Xticks))
box(ax1,'off')
set(ax1,'fontsize',10,'fontweight','bold')
%%% the second axes
ax2=axes('Position',ax1.Position,'xlim', [dis_min, dis_max], 'color', 'none',...
    'YTick',[],'YColor','none','XColor','k', 'XAxisLocation', 'top');
Xticks = round(linspace(dis_min,dis_max,6),2);
xticks(ax2,Xticks);
ax2.XAxis.Exponent = 0;
Yticks = round(linspace(y_min,y_max,6),2);
xticklabels(ax2,string(Yticks))
set(ax2,'fontsize',10,'fontweight','bold')
xlabel(ax2,'Y Profile (m)','color','k');

set(gcf,'color','w');
img = getframe(gcf);
imwrite(img.cdata, [fullfile(fpath,strcat(figname,num2str(fignum))), '.png']);
if ExportEPSFig == 1
    % Save eps Figure
    figname= figname(find(~isspace(figname)));
    print(gcf,'-depsc2','-painters',fullfile(fpath,strcat(figname,num2str(fignum))));
end
end