function PLOT_raw_standardized_residuals(Chain_best,Chain_raw,Cov_g,Cov_T,fpath)
global ExportEPSFig
figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
[xz, rho, sus] = Chian2xz(Chain_best);
[model_g, model_T] = xz2model(xz(1,:),xz(2,:),rho,sus);
[rg, rT] = ForwardModel(model_g, model_T);
Xig = Chain_best(1,3);
Cov_g = Xig*Cov_g;
Lg = chol(Cov_g,'lower');
sr_g = Lg^-1 * rg;
[c,lags] = xcov(sr_g,'coeff');
subplot(2,1,1)
plot(lags(lags>=0), c(lags>=0),'k--','LineWidth',2);
hold on
Chain_raw = topkrows(Chain_raw,1,'descend');
[xz, rho, sus] = Chian2xz(Chain_raw);
[model_g, model_T] = xz2model(xz(1,:),xz(2,:),rho,sus);
[rg_raw, rT_raw] = ForwardModel(model_g, model_T);
[c_raw,lags] = xcov(rg_raw,'coeff');
plot(lags(lags>=0), c_raw(lags>=0),'k-','LineWidth',2);
% plot(0:length(rg_raw)-1,autocorr(rg_raw,length(rg_raw)-1),'b.-','LineWidth',2);
ylabel('autocorrelation (Gravity)'),xlabel('lag'),set(gca,'fontsize',10,'fontweight','bold')
legend('autocorrelation of standardized residuals','autocorrelation of raw residuals')

subplot(2,1,2)
XiT = Chain_best(1,4);
Cov_T = XiT*Cov_T;
LT = chol(Cov_T,'lower');
sr_T = LT^-1 * rT;
[c,lags] = xcov(sr_T,'coeff');
plot(lags(lags>=0), c(lags>=0),'k--','LineWidth',2);
hold on
[c_raw,lags] = xcov(rT_raw,'coeff');
plot(lags(lags>=0), c_raw(lags>=0),'k-','LineWidth',2);
% plot(0:length(rT_raw)-1,autocorr(rT_raw,length(rT_raw)-1),'b.-','LineWidth',2);
ylabel('autocorrelation (Magnetic)'),xlabel('lag'),set(gca,'fontsize',10,'fontweight','bold')
legend('autocorrelation of standardized residuals','autocorrelation of raw residuals')

figname = 'Autocorr of raw and standardized';
set(gcf,'color','w');
img = getframe(gcf);
imwrite(img.cdata, [fullfile(fpath,figname),'.png']);
if ExportEPSFig == 1
    % Save eps Figure
    figname= figname(find(~isspace(figname)));
    print(gcf,'-depsc2','-painters',fullfile(fpath,figname));
end


%%% Plot the Histogram of standardized and raw residuals
figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
xnormal = (-4:.1:4);
ynormal = normpdf(xnormal,0,1);
subplot(2,1,1)
plot(xnormal,ynormal,'LineWidth',2), hold on,
histogram(sr_g,10,'Normalization','pdf','DisplayStyle','bar','LineWidth',2,'EdgeColor',[0 0 0],'FaceColor',[0.5 0.5 0.5])
hold on
histogram(rg_raw,10,'LineStyle',':','Normalization','pdf','DisplayStyle','stairs','LineWidth',2,'EdgeColor',[1 0 0])
xlabel('residuals (mGal)'),ylabel('probability distribution function'),set(gca,'fontsize',10,'fontweight','bold'),drawnow
legend('normal distribution','standardized residuals','raw residuals')

subplot(2,1,2)
plot(xnormal,ynormal,'LineWidth',2), hold on,
histogram(sr_T,10,'Normalization','pdf','DisplayStyle','bar','LineWidth',2,'EdgeColor',[0 0 0],'FaceColor',[0.5 0.5 0.5])
hold on
histogram(rT_raw,10,'LineStyle',':','Normalization','pdf','DisplayStyle','stairs','LineWidth',2,'EdgeColor',[1 0 0])
xlabel('residuals (nT)'),ylabel('probability distribution function'),set(gca,'fontsize',10,'fontweight','bold'),drawnow
legend('normal distribution','standardized residuals','raw residuals')

figname = 'Hist of raw and standardized';
set(gcf,'color','w');
img = getframe(gcf);
imwrite(img.cdata, [fullfile(fpath,figname), '.png']);
if ExportEPSFig == 1
    % Save eps Figure
    figname= figname(find(~isspace(figname)));
    print(gcf,'-depsc2','-painters',fullfile(fpath,figname));
end
end