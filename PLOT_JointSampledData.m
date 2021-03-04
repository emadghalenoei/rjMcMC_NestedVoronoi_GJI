function PLOT_JointSampledData(datakeep_dg,datakeep_dT,fpath,figname,fignum)
global  dg_obs dT_obs x_min x_max y_min y_max dis_dg dis_dT ExportEPSFig dis_min dis_max 
%%% Plot Data
figure('units','normalized','outerposition',[0 0 1 1],'visible','off');

subplot(1,2,1)
if size(datakeep_dg,2)<=5000
    istart = 1;
else
    istart = size(datakeep_dg,2)-5000;
end
for i=istart:size(datakeep_dg,2)
    p1=plot(dis_dg/1000,datakeep_dg(:,i),'color',[0.5 0.5 0.5]);
    hold on
end
p2=plot(dis_dg/1000,dg_obs,'k.-','LineWidth',1,'markersize',15);
ylabel('Gravity (mGal)')
xlabel('X Profile (km)')
xlim([dis_min/1000 dis_max/1000])
xtickangle(0)
ax1 = gca;
Xticks = round(linspace(dis_min-dis_min,dis_max-dis_min,6)/1000,2);
xticks(ax1,Xticks);
ax1.XAxis.Exponent = 0;
% Xticks = round(linspace(x_min,x_max,6)/1000,2);
xticklabels(ax1,string(Xticks))
box(ax1,'off')
title('(a)')
set(gca,'fontsize',17,'fontweight','bold')

%%% the second axes
% ax2=axes('Position',ax1.Position,'xlim', [dis_min/1000, dis_max/1000], 'color', 'none',...
%     'YTick',[],'YColor','none','XColor','k', 'XAxisLocation', 'top');
% Xticks = round(linspace(dis_min,dis_max,6)/1000,2);
% xticks(ax2,Xticks);
% ax2.XAxis.Exponent = 0;
% Yticks = round(linspace(y_min,y_max,6)/1000,2);
% xticklabels(ax2,string(Yticks))
% set(ax2,'fontsize',10,'fontweight','bold')
% xlabel(ax2,'Y Profile (km)','color','k');
% % legend([p1 p2],{'Sampled data','Observed data'},'Location','best')

subplot(1,2,2)
for i=istart:size(datakeep_dT,2)
    p1=plot(dis_dT/1000,datakeep_dT(:,i),'color',[0.5 0.5 0.5],'LineWidth',4);
    hold on
end
p2=plot(dis_dT/1000,dT_obs,'k.-','LineWidth',0.5,'markersize',15);
ylabel('Magnetic (nT)')
xlabel('X Profile (km)')
xlim([dis_min/1000 dis_max/1000])
xtickangle(0)
ax1 = gca;
Xticks = round(linspace(dis_min-dis_min,dis_max-dis_min,6)/1000,2);
xticks(ax1,Xticks);
ax1.XAxis.Exponent = 0;
% Xticks = round(linspace(x_min,x_max,6)/1000,2);
xticklabels(ax1,string(Xticks))
box(ax1,'off')
title('(b)')
set(gca,'fontsize',17,'fontweight','bold')
% %%% the second axes
% ax2=axes('Position',ax1.Position,'xlim', [dis_min/1000, dis_max/1000], 'color', 'none',...
%     'YTick',[],'YColor','none','XColor','k', 'XAxisLocation', 'top');
% Xticks = round(linspace(dis_min,dis_max,6)/1000,2);
% xticks(ax2,Xticks);
% ax2.XAxis.Exponent = 0;
% Yticks = round(linspace(y_min,y_max,6)/1000,2);
% xticklabels(ax2,string(Yticks))
% set(ax2,'fontsize',10,'fontweight','bold')
% xlabel(ax2,'Y Profile (km)','color','k');
% legend([p1 p2],{'Sampled data','Observed data'},'Location','best')
% saveas(gca, fullfile(fpath,'Data'),'png');
set(gcf,'color','w');
img = getframe(gcf);
imwrite(img.cdata, [fullfile(fpath,strcat(figname,num2str(fignum))), '.png'])
% Save eps Figure
if ExportEPSFig == 1
    % Save eps Figure
    figname= figname(find(~isspace(figname)));
    print(gcf,'-depsc2','-painters',fullfile(fpath,strcat(figname,num2str(fignum))));
end
end