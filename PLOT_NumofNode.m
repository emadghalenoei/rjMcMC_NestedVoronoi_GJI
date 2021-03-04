function PLOT_NumofNode(timeOFsteps,NumofNode,fpath,figname,fignum)
global ExportEPSFig
% %%% Plot K
% timeOFsteps = timeOFsteps/60; % convert sec to min
% STEPS = 1:length(NumofNode);
% figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
% 
% 
% subplot(1,2,1)
% histogram(NumofNode,6,'Normalization','pdf','Orientation', 'horizontal','DisplayStyle','bar','LineWidth',2,'EdgeColor',[0 0 0],'FaceColor',[0.5 0.5 0.5]), hold on
% % plot(linspace(0,0.25,50),mode(NumofNode).*ones(size(linspace(0,0.15,50))),'b--','linewidth',2)
% ylabel('Number of nodes (k)')
% xlabel('pdf'), set(gca,'fontsize',15,'fontweight','bold'),ylim([4 max(NumofNode)+1])
% xtickangle(0),ax1 = gca; ax1.XAxis.Exponent = 0;
% box(ax1,'off')
% % xlim([0 0.5])
% 
% subplot(1,2,2)
% plot(STEPS,NumofNode,'color','black'),hold on,
% % plot(timeOFsteps,mode(NumofNode).*ones(size(NumofNode)),'b--','LineWidth',2)
% % xlabel('Elapsed time (min)')
% xlabel('rjMCMC steps')
% set(gca,'fontsize',15,'fontweight','bold'),ylim([4 max(NumofNode)+1]),xtickangle(0),ax1 = gca; ax1.XAxis.Exponent = 0;
% ax2=axes('Position',ax1.Position,'xlim', [timeOFsteps(1) timeOFsteps(end)], 'color', 'none',...
% 'YTick',[],'YColor','none','XColor','k', 'XAxisLocation', 'top');
% ax2.XAxis.Exponent = 0;
% set(ax2,'fontsize',10,'fontweight','bold')
% xlabel(ax2,'Elapsed time (min)','color','k');
% box(ax1,'off')


figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
histogram(NumofNode,5,'Normalization','pdf','Orientation', 'vertical','DisplayStyle','bar','LineWidth',2,'EdgeColor',[0 0 0],'FaceColor',[0.5 0.5 0.5]), hold on
xlabel('Number of nodes (k)')
ylabel('pdf'), set(gca,'fontsize',15,'fontweight','bold'),xlim([4 max(NumofNode)+1])
xtickangle(0),ax1 = gca; ax1.XAxis.Exponent = 0;
box(ax1,'off')

set(gcf,'color','w');
img = getframe(gcf);
imwrite(img.cdata, [fullfile(fpath,strcat(figname,num2str(fignum))), '.png']);

% Save eps Figure
if ExportEPSFig == 1
    figname= figname(find(~isspace(figname)));
    print(gcf,'-depsc2','-painters',fullfile(fpath,strcat(figname,num2str(fignum))));
end
end