function PLOT_COL_MeanCIs(col,TrueModel,PMD,CI_L,CI_H,fpath,LIMIT,figname,fignum)
global Z ExportEPSFig rho_salt_min rho_basement_max
figure('units','normalized','outerposition',[0 0 1 1],'visible','off');

NumofPlots = length(col);
for i = 1: NumofPlots
    
    subplot(1,NumofPlots,i)
    plot(PMD(:,col(i)),Z(:,1),'k--','linewidth',2)
    hold on
    plot(CI_L(:,col(i)),Z(:,1),'color',[0.5 0.5 0.5],'linewidth',2)
    hold on
    plot(CI_H(:,col(i)),Z(:,1),'color',[0.5 0.5 0.5],'linewidth',2)
    hold on
    plot(TrueModel(:,col(i)),Z(:,1),'r.-','linewidth',1,'markersize',8)
    set(gca,'Ydir','reverse')
    
    xlabel(strcat(figname,' X',num2str(i)))
    xmin = min([PMD(:,col(i)),CI_L(:,col(i)), CI_H(:,col(i)),TrueModel(:,col(i))],[],'all');
    xmax = max([PMD(:,col(i)),CI_L(:,col(i)), CI_H(:,col(i)),TrueModel(:,col(i))],[],'all');
    %     xlim([xmin-0.1 xmax+0.1])
%     xlim([rho_salt_min-0.1 rho_basement_max+0.1])
    xlim(LIMIT)
    
    ax1 = gca;
    if i == 1
        ylabel('Depth (m)')
    else
        yticklabels({})
    end
    box(ax1,'off')
    set(gca,'fontsize',10,'fontweight','bold')
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