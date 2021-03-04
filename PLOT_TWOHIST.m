function PLOT_TWOHIST(LogLikelihood,fpath,figname,fignum)
global ExportEPSFig
NSAMPLE = length(LogLikelihood);
SAMPLETHIRD = floor(NSAMPLE/3);

LogL_1 = LogLikelihood(1:SAMPLETHIRD);
% LogL_2 = LogLikelihood(SAMPLETHIRD+1:2*SAMPLETHIRD);
LogL_3 = LogLikelihood(2*SAMPLETHIRD+1:3*SAMPLETHIRD);

limmin = min(LogLikelihood)-10;
limmax = max(LogLikelihood)+10;


h1 = histogram(LogL_1,'Normalization','pdf');
h3 = histogram(LogL_3,'Normalization','pdf');

figure('units','normalized','outerposition',[0 0 1 1],'visible','off');

plot(h1.BinEdges, [0 h1.Values], 'k-', 'LineWidth', 1.5);
hold on
plot(h3.BinEdges, [0 h3.Values], '--','color',[0.5 0.5 0.5], 'LineWidth', 3, 'MarkerSize', 20);

xlim([limmin  limmax]);
xtickangle(0)
ax1 = gca;
ax1.XAxis.Exponent = 0;
xlabel(figname);
ylabel('pdf'), set(gca,'fontweight','bold','fontsize',15);
xtickangle(0)
ax1 = gca;
ax1.XAxis.Exponent = 0;
box(ax1,'off')
drawnow
legend('The first 1/3 of chain','The last 1/3 of chain','Location','best')
% saveas(h, fullfile(fpath,'LogL'),'png');
set(gcf,'color','w');
img = getframe(gcf);
imwrite(img.cdata, [fullfile(fpath,strcat(figname,num2str(fignum))), '.png']);
if ExportEPSFig == 1
    figname= figname(find(~isspace(figname)));
    print(gcf,'-depsc2','-painters',fullfile(fpath,strcat(figname,num2str(fignum))));
end
end