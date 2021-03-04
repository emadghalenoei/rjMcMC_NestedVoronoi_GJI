function PLOT_LOGL(timeOFsteps,LogLikelihood,NumofNode,fpath,figname,fignum)
global ExportEPSFig
%%% Plot LogL
figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
Best_LogL = mean(LogLikelihood(NumofNode == mode(NumofNode)));
timeOFsteps = timeOFsteps/60; % convert sec to min
STEPS = 1:length(LogLikelihood);
subplot(1,2,1)
plot(STEPS,LogLikelihood,'color',[0.5 0.5 0.5],'LineWidth',2),hold on, plot(STEPS,Best_LogL.*ones(size(LogLikelihood)),'b--','LineWidth',2)
ylabel('Log Likelihood'), xlabel('rjMCMC steps'), set(gca,'fontsize',15,'fontweight','bold'),
ylim([Best_LogL-40 Best_LogL+40]),xtickangle(0),
ax1 = gca; ax1.XAxis.Exponent = 0;
%%% the second axes (MCMC iterations)
ax2=axes('Position',ax1.Position,'xlim', [timeOFsteps(1) timeOFsteps(end)], 'color', 'none',...
'YTick',[],'YColor','none','XColor','k', 'XAxisLocation', 'top');
ax2.XAxis.Exponent = 0;
set(ax2,'fontweight','bold','fontsize',10);
xlabel(ax2,'Elapsed time (min)','color','k');
box(ax1,'off')

subplot(1,2,2)
histogram(LogLikelihood,'Normalization','pdf','Orientation', 'horizontal','DisplayStyle','stairs','LineWidth',2,'EdgeColor',[0 0 0]),hold on
plot(linspace(0,0.25,50),Best_LogL.*ones(size(linspace(0,0.15,50))),'b--','linewidth',2)
ylim([Best_LogL-40  Best_LogL+40]),
xtickangle(0)
ax1 = gca;
ax1.XAxis.Exponent = 0;
xlabel('pdf'), set(gca,'fontweight','bold','fontsize',15);
xtickangle(0)
ax1 = gca;
ax1.XAxis.Exponent = 0;
box(ax1,'off')
drawnow
% saveas(h, fullfile(fpath,'LogL'),'png');
set(gcf,'color','w');
img = getframe(gcf);
imwrite(img.cdata, [fullfile(fpath,strcat(figname,num2str(fignum))), '.png']);
if ExportEPSFig == 1
    figname= figname(find(~isspace(figname)));
    print(gcf,'-depsc2','-painters',fullfile(fpath,strcat(figname,num2str(fignum))));
end
end