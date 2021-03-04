function PLOT_SigmaNoise(timeOFsteps,sigma,fpath,figname,fignum)
global ExportEPSFig
%%% Plot Sigma
timeOFsteps = timeOFsteps/60; % convert sec to min
STEPS = 1:length(sigma);
figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
subplot(1,2,1)
plot(STEPS,sigma,'color','black'),hold on,
% plot(timeOFsteps,mode(NumofNode).*ones(size(NumofNode)),'b--','LineWidth',2)
ylabel(figname);
xlabel('rjMCMC steps')
ylimmax = max(sigma)+0.5;
set(gca,'fontsize',15,'fontweight','bold'),ylim([0 ylimmax]),xtickangle(0),ax1 = gca; ax1.XAxis.Exponent = 0;
ax2=axes('Position',ax1.Position,'xlim', [timeOFsteps(1) timeOFsteps(end)], 'color', 'none',...
'YTick',[],'YColor','none','XColor','k', 'XAxisLocation', 'top');
ax2.XAxis.Exponent = 0;
set(ax2,'fontsize',10,'fontweight','bold')
xlabel(ax2,'Elapsed time (min)','color','k');
box(ax1,'off')

subplot(1,2,2)
histogram(sigma,'Normalization','pdf','Orientation', 'horizontal','DisplayStyle','bar','LineWidth',2,'EdgeColor',[0 0 0],'FaceColor',[0.5 0.5 0.5]), hold on
xlabel('pdf'), set(gca,'fontsize',15,'fontweight','bold'),ylim([0 ylimmax])
xtickangle(0),ax1 = gca; ax1.XAxis.Exponent = 0;
box(ax1,'off')
% saveas(gca, fullfile(fpath,'NumofNode'),'png');
set(gcf,'color','w');
img = getframe(gcf);
imwrite(img.cdata, [fullfile(fpath,strcat(figname,num2str(fignum))), '.png']);
% Save eps Figure
if ExportEPSFig == 1
    figname= figname(find(~isspace(figname)));
    print(gcf,'-depsc2','-painters',fullfile(fpath,strcat(figname,num2str(fignum))));
end
end