function PLOT_RHOHIST(RHOkeep,fpath,figname,fignum)
global ExportEPSFig

RHOkeep = RHOkeep(:);
RHOkeep(isnan(RHOkeep)) = [];
RHOkeep_salt = RHOkeep;
RHOkeep_basement = RHOkeep;
RHOkeep_salt(RHOkeep_salt>=0) = [];
RHOkeep_salt(isnan(RHOkeep_salt)) = [];
RHOkeep_basement(RHOkeep_basement<=0) = [];
RHOkeep_basement(isnan(RHOkeep_basement)) = [];


%%% Plot rho hist
figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
subplot(3,1,1)
histogram(RHOkeep,'Normalization','pdf','DisplayStyle','bar','LineWidth',2,'EdgeColor',[0 0 0],'FaceColor',[0.5 0.5 0.5]), hold on
% plot(linspace(0,0.25,50),mode(NumofNode).*ones(size(linspace(0,0.15,50))),'b--','linewidth',2)
ylabel('pdf')
xlabel('density all (gr/cm^{3}'), set(gca,'fontsize',15,'fontweight','bold')
xtickangle(0),ax1 = gca; ax1.XAxis.Exponent = 0;
box(ax1,'off')

subplot(3,1,2)
histogram(RHOkeep_salt,'Normalization','pdf','DisplayStyle','bar','LineWidth',2,'EdgeColor',[0 0 0],'FaceColor',[0.5 0.5 0.5]), hold on
% plot(linspace(0,0.25,50),mode(NumofNode).*ones(size(linspace(0,0.15,50))),'b--','linewidth',2)
ylabel('pdf')
xlabel('density salt (gr/cm^{3})'), set(gca,'fontsize',15,'fontweight','bold')
xtickangle(0),ax1 = gca; ax1.XAxis.Exponent = 0;
box(ax1,'off')

subplot(3,1,3)
histogram(RHOkeep_basement,'Normalization','pdf','DisplayStyle','bar','LineWidth',2,'EdgeColor',[0 0 0],'FaceColor',[0.5 0.5 0.5]), hold on
% plot(linspace(0,0.25,50),mode(NumofNode).*ones(size(linspace(0,0.15,50))),'b--','linewidth',2)
ylabel('pdf')
xlabel('density basement (gr/cm^{3})'), set(gca,'fontsize',15,'fontweight','bold')
xtickangle(0),ax1 = gca; ax1.XAxis.Exponent = 0;
box(ax1,'off')


set(gcf,'color','w');
img = getframe(gcf);
imwrite(img.cdata, [fullfile(fpath,strcat(figname,num2str(fignum))), '.png']);
% Save eps Figure
% Save eps Figure
if ExportEPSFig == 1
    figname= figname(find(~isspace(figname)));
    print(gcf,'-depsc2','-painters',fullfile(fpath,strcat(figname,num2str(fignum))));
end
end