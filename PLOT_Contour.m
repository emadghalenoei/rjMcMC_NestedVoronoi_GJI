function PLOT_Contour(x,z,PMD,c,fpath,LIMIT,clrmap,figname,fignum)
global y_min y_max x_min x_max   dis_intsc   ExportEPSFig dis_min dis_max
figure('units','normalized','outerposition',[0 0 1 1],'visible','off');

imagesc(x,z,PMD)
cbar=colorbar;cbar.Label.String = figname;
caxis(LIMIT)
axis square
hold on
contour(x,z,PMD,[c c],'Color','black','LineWidth',2);
% clabel(C,h,'FontSize',15,'Color',[0.8500 0.3250 0.0980],'FontWeight','bold')

xlim([dis_min dis_max])

ax1=gca;
ax1.XAxis.TickLabelRotation = 0;
ax1.XAxis.Exponent = 0;
set(ax1,'fontsize',15,'fontweight','bold')
Xticks = round(linspace(dis_min,dis_max,6),2);
xticks(ax1,Xticks);
ax1.XAxis.Exponent = 0;
Xticks = round(linspace(x_min,x_max,6),2);
xticklabels(ax1,string(Xticks))
% xtickformat('%.0f')

if contains(clrmap, 'jet')
    mycolormap = jet;
    mycolormap(1,:) =1;
    colormap(mycolormap);
elseif contains(clrmap, 'bluewhitered')
    colormap(bluewhitered);
elseif contains(clrmap, 'WhiteBlueGreenYellowRed')
    WhiteBlueGreenYellowRed = load('WhiteBlueGreenYellowRed.txt');
    colormap(WhiteBlueGreenYellowRed);
end

set(gca,'Ydir','reverse')
ylabel('Depth (m)'),xlabel('X Profile (m)')
shading interp
hold on
% quiver(dis_intsc(1), 5000,dis_intsc(2)-dis_intsc(1),0,0,'Color','black','linewidth',3,'MaxHeadSize',0.1)
% hold on
% quiver(dis_intsc(2), 5000,dis_intsc(1)-dis_intsc(2),0,0,'Color','black','linewidth',3,'MaxHeadSize',0.1)
% text(mean([dis_intsc(1),dis_intsc(2)])-5000,5000-300,'Ghasha','fontsize',15,'Color','black','FontWeight','bold')


%%% the second axes (MCMC iterations)
ax2=axes('Position',ax1.Position,'xlim', [dis_min, dis_max], 'color', 'none',...
    'YTick',[],'YColor','none','XColor','k', 'XAxisLocation', 'top');
Xticks = round(linspace(dis_min,dis_max,6),2);
xticks(ax2,Xticks);
ax2.XAxis.Exponent = 0;
Yticks = round(linspace(y_min,y_max,6),2);
xticklabels(ax2,string(Yticks))
set(ax2,'fontsize',10,'fontweight','bold')
xlabel(ax2,'Y Profile (m)','color','k');
axis square
% box(ax2,'off')

% Save Figure
set(gcf,'color','w');
img = getframe(gcf);
figname = strrep(figname,'(gr/cm^{3})',[]);
imwrite(img.cdata, [fullfile(fpath,strcat(figname,num2str(fignum))), '.png']);
% Save eps Figure
if ExportEPSFig == 1
    figname= figname(find(~isspace(figname)));
    print(gcf,'-depsc2','-painters',fullfile(fpath,strcat(figname,num2str(fignum))));
end
end