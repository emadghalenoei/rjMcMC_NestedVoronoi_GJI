function PLOT_Joint_Data_CI(data_mean_dg, data_CI_dg,data_mean_dT, data_CI_dT,fpath,figname,fignum)
global  dg_obs  dT_obs x_min x_max y_min y_max  ExportEPSFig dis_dg dis_dT dis_min dis_max
%%% Plot Data and its CI
figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
subplot(1,2,1)
plot(dis_dg,dg_obs,'bx-','color','blue','LineWidth',2,'markersize',10);
grid on
hold on
plot(dis_dg,data_mean_dg,'color','red','LineWidth',2);
hold on
plot(dis_dg,data_CI_dg(:,1),'color','black','LineWidth',2);
hold on
plot(dis_dg,data_CI_dg(:,2),'color','black','LineWidth',2);
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
set(gca,'fontsize',10,'fontweight','bold')
legend('Observed data','posterior mean of data predictions','95 per cent CIs','Location','best')
%%% the second axes
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
plot(dis_dT,dT_obs,'bx-','color','blue','LineWidth',2,'markersize',10);
grid on
hold on
plot(dis_dT,data_mean_dT,'color','red','LineWidth',2);
hold on
plot(dis_dT,data_CI_dT(:,1),'color','black','LineWidth',2);
hold on
plot(dis_dT,data_CI_dT(:,2),'color','black','LineWidth',2);
ylabel('Magnetic (nT)')
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
set(gca,'fontsize',10,'fontweight','bold')
legend('Observed data','posterior mean of data predictions','95 per cent CIs','Location','best')
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

% saveas(h, fullfile(fpath,'Data_UQ'),'png');
set(gcf,'color','w');
img = getframe(gcf);
imwrite(img.cdata, [fullfile(fpath,strcat(figname,num2str(fignum))), '.png'])
% Save eps Figure
if ExportEPSFig == 1
    figname= figname(find(~isspace(figname)));
    print(gcf,'-depsc2','-painters',fullfile(fpath,strcat(figname,num2str(fignum))));
end
end