function PLOT_TWOKCELL(timeOFsteps,KCELL,fpath,figname,fignum)
global ExportEPSFig
%%% Plot K
timeOFsteps = timeOFsteps/60; % convert sec to min
STEPS = 1:length(timeOFsteps);
figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
subplot(2,2,1)
plot(STEPS,KCELL(:,1),'color','black'),hold on,
% plot(timeOFsteps,mode(NumofNode).*ones(size(NumofNode)),'b--','LineWidth',2)
ylabel('k (sediments)')
% xlabel('rjMCMC steps')
xticklabels({})
set(gca,'fontsize',15,'fontweight','bold'),ylim([0 max(KCELL(:,1))+1]),xtickangle(0),ax1 = gca; ax1.XAxis.Exponent = 0;
ax2=axes('Position',ax1.Position,'xlim', [timeOFsteps(1) timeOFsteps(end)], 'color', 'none',...
'YTick',[],'YColor','none','XColor','k', 'XAxisLocation', 'top');
ax2.XAxis.Exponent = 0;
set(ax2,'fontsize',10,'fontweight','bold')
xlabel(ax2,'Elapsed time (min)','color','k');
box(ax1,'off')

subplot(2,2,2)
histogram(KCELL(:,1),10,'Normalization','pdf','Orientation', 'horizontal','DisplayStyle','bar','LineWidth',2,'EdgeColor',[0 0 0],'FaceColor',[0.5 0.5 0.5]), hold on
% plot(linspace(0,0.25,50),mode(NumofNode).*ones(size(linspace(0,0.15,50))),'b--','linewidth',2)
% ylabel('k')
% xlabel('pdf')
set(gca,'fontsize',15,'fontweight','bold'),ylim([0 max(KCELL(:,1))+1])
xtickangle(0),ax1 = gca; ax1.XAxis.Exponent = 0;
box(ax1,'off')
% xlim([0 0.5])

subplot(2,2,3)
plot(STEPS,KCELL(:,2)+ KCELL(:,3),'color','black'),hold on,
% plot(timeOFsteps,mode(NumofNode).*ones(size(NumofNode)),'b--','LineWidth',2)
ylabel('k (salt and basement)')
% xlabel('rjMCMC steps')
xticklabels({})
set(gca,'fontsize',15,'fontweight','bold'),ylim([0 max(KCELL(:,2)+KCELL(:,3))+1]),xtickangle(0),ax1 = gca; ax1.XAxis.Exponent = 0;
ax2=axes('Position',ax1.Position,'xlim', [timeOFsteps(1) timeOFsteps(end)], 'color', 'none',...
'YTick',[],'YColor','none','XColor','k', 'XAxisLocation', 'top');
ax2.XAxis.Exponent = 0;
set(ax2,'fontsize',10,'fontweight','bold')
% xlabel(ax2,'Elapsed time (min)','color','k');
xticklabels(ax2,{})
box(ax1,'off')

subplot(2,2,4)
histogram(KCELL(:,2)+KCELL(:,3),10,'Normalization','pdf','Orientation', 'horizontal','DisplayStyle','bar','LineWidth',2,'EdgeColor',[0 0 0],'FaceColor',[0.5 0.5 0.5]), hold on
% plot(linspace(0,0.25,50),mode(NumofNode).*ones(size(linspace(0,0.15,50))),'b--','linewidth',2)
% ylabel('k')
% xlabel('pdf')
set(gca,'fontsize',15,'fontweight','bold'),ylim([0 max(KCELL(:,2)+ KCELL(:,3))+1])
xtickangle(0),ax1 = gca; ax1.XAxis.Exponent = 0;
box(ax1,'off')
% xlim([0 0.5])


set(gcf,'color','w');
img = getframe(gcf);
imwrite(img.cdata, [fullfile(fpath,strcat(figname,num2str(fignum))), '.png'])
% Save eps Figure
if ExportEPSFig == 1
    figname= figname(find(~isspace(figname)));
    print(gcf,'-depsc2','-painters',fullfile(fpath,strcat(figname,num2str(fignum))));
end
end