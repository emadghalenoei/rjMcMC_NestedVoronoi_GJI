function PLOT_Avg_residuals(res_g,res_T,Chain_raw,Cov_g,Cov_T,fpath)
global ExportEPSFig dg_obs dT_obs

sr_g = zeros(size(res_g));
sr_T = zeros(size(res_T));
Lg = chol(Cov_g,'lower');
LT = chol(Cov_T,'lower');
cg = zeros(size(res_g,2),2*length(dg_obs)-1);
cT = zeros(size(res_T,2),2*length(dT_obs)-1);
for i=1:size(res_g,2)
    sr_g(:,i) = Lg^-1 * res_g(:,i);
    sr_T(:,i) = LT^-1 * res_T(:,i);
    [cg(i,:),lags] = xcov(sr_g(:,i),'coeff');
    [cT(i,:),lags] = xcov(sr_T(:,i),'coeff');
end
cgmean = mean(cg,1);
cTmean = mean(cT,1);
sr_g_mean = mean(sr_g,2);
sr_T_mean = mean(sr_T,2);


figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
subplot(2,1,1)
plot(lags(lags>=0), cgmean(lags>=0),'k--','LineWidth',2);
hold on
Chain_raw = topkrows(Chain_raw,1,'descend');
[xz, rho, sus] = Chian2xz(Chain_raw);
[model_g, model_T] = xz2model(xz(1,:),xz(2,:),rho,sus);
[rg_raw, rT_raw] = ForwardModel(model_g, model_T);
[c_raw,lags] = xcov(rg_raw,'coeff');
plot(lags(lags>=0), c_raw(lags>=0),'k-','LineWidth',2);
% plot(0:length(rg_raw)-1,autocorr(rg_raw,length(rg_raw)-1),'b.-','LineWidth',2);
ylabel('ACF (Gravity)'),xlabel('lag'),set(gca,'fontsize',20,'fontweight','bold')
% legend('autocorrelation of standardized residuals','autocorrelation of raw residuals')

subplot(2,1,2)
plot(lags(lags>=0), cTmean(lags>=0),'k--','LineWidth',2);
hold on
[c_raw,lags] = xcov(rT_raw,'coeff');
plot(lags(lags>=0), c_raw(lags>=0),'k-','LineWidth',2);
% plot(0:length(rT_raw)-1,autocorr(rT_raw,length(rT_raw)-1),'b.-','LineWidth',2);
ylabel('ACF (Magnetic)'),xlabel('lag'),set(gca,'fontsize',20,'fontweight','bold')
% legend('autocorrelation of standardized residuals','autocorrelation of raw residuals')

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
histogram(sr_g_mean,10,'Normalization','pdf','DisplayStyle','bar','LineWidth',2,'EdgeColor',[0 0 0],'FaceColor',[0.5 0.5 0.5])
hold on
histogram(rg_raw,10,'LineStyle',':','Normalization','pdf','DisplayStyle','stairs','LineWidth',2,'EdgeColor',[1 0 0])
xlabel('residuals (mGal)'),ylabel('pdf'),set(gca,'fontsize',20,'fontweight','bold'),drawnow
% legend('normal distribution','standardized residuals','raw residuals')

subplot(2,1,2)
plot(xnormal,ynormal,'LineWidth',2), hold on,
histogram(sr_T_mean,10,'Normalization','pdf','DisplayStyle','bar','LineWidth',2,'EdgeColor',[0 0 0],'FaceColor',[0.5 0.5 0.5])
hold on
histogram(rT_raw,10,'LineStyle',':','Normalization','pdf','DisplayStyle','stairs','LineWidth',2,'EdgeColor',[1 0 0])
xlabel('residuals (nT)'),ylabel('pdf'),set(gca,'fontsize',20,'fontweight','bold'),drawnow
% legend('normal distribution','standardized residuals','raw residuals')


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