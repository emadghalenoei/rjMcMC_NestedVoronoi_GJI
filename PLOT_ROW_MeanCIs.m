function PLOT_ROW_MeanCIs(row,TrueModel,PMD,CI_L,CI_H,fpath,LIMIT,figname,fignum)
global y_min y_max x_min x_max ExportEPSFig DISMODEL dis_min dis_max rho_salt_min rho_basement_max sus_basement_max
figure('units','normalized','outerposition',[0 0 1 1],'visible','off');

NumofPlots = length(row);
for i = 1: NumofPlots
    
    subplot(NumofPlots,1,i)
    plot(DISMODEL(1,:),PMD(row(i),:),'k--','linewidth',2)
    hold on
    plot(DISMODEL(1,:),CI_L(row(i),:),'color',[0.5 0.5 0.5],'linewidth',2)
    hold on
    plot(DISMODEL(1,:),CI_H(row(i),:),'color',[0.5 0.5 0.5],'linewidth',2)
    hold on
    plot(DISMODEL(1,:),TrueModel(row(i),:),'r.-','linewidth',1,'markersize',8)
    
    ylabel(strcat(figname,' Z',num2str(i)))
    xlim([dis_min dis_max])
    ymin = min([PMD(row(i),:),CI_L(row(i),:), CI_H(row(i),:),TrueModel(row(i),:)],[],'all');
    ymax = max([PMD(row(i),:),CI_L(row(i),:), CI_H(row(i),:),TrueModel(row(i),:)],[],'all');
%     ylim([ymin-0.1 ymax+0.1])
    ylim(LIMIT)
    
    xtickangle(0)
    ax1 = gca;
    if i == NumofPlots
        xlabel('X Profile (m)')
        Xticks = round(linspace(dis_min,dis_max,6),2);
        xticks(ax1,Xticks);
        ax1.XAxis.Exponent = 0;
        Xticks = round(linspace(x_min,x_max,6),2);
        xticklabels(ax1,string(Xticks))
    else
        xticklabels({})
    end
    box(ax1,'off')
    set(gca,'fontsize',10,'fontweight','bold')
    %%% the second axes
    if i == 1
        ax2=axes('Position',ax1.Position,'xlim', [dis_min, dis_max], 'color', 'none',...
            'YTick',[],'YColor','none','XColor','k', 'XAxisLocation', 'top');
        Xticks = round(linspace(dis_min,dis_max,6),2);
        xticks(ax2,Xticks);
        ax2.XAxis.Exponent = 0;
        Yticks = round(linspace(y_min,y_max,6),2);
        xticklabels(ax2,string(Yticks))
        set(ax2,'fontsize',10,'fontweight','bold')
        xlabel(ax2,'Y Profile (m)','color','k');
    end
end



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