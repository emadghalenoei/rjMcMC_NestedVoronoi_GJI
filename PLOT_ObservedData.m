function PLOT_ObservedData(fpath,figname,fignum)
global xs_dg dg_obs xs_dT dT_obs x_min x_max y_min y_max  dis_dg dis_dT dis_min dis_max
figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
subplot(1,2,1)
plot(dis_dg,dg_obs,'k*-','LineWidth',2);
hold on
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
end