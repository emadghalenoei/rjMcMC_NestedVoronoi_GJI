function PLOT_ACF_Hist_residuals(res_g,res_T,Chain_raw,Cov_g,Cov_T,fpath)
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


figure('units','normalized','outerposition',[0 0 1 1],'visible','on');
left = 0.1;
bottom = 0.55;
width = 0.3;
height = 0.2;
dw = 0.02; % between subplots
dh = 0.02; % between subplots
pos1 = [left bottom width height];
h1=subplot('Position',pos1);
plot(lags(lags>=0), cgmean(lags>=0),'k--','LineWidth',2);
hold on
Chain_raw = topkrows(Chain_raw,1,'descend');
[xz, rho, sus] = Chian2xz(Chain_raw);
[model_g, model_T] = xz2model(xz(1,:),xz(2,:),rho,sus);
[rg_raw, rT_raw] = ForwardModel(model_g, model_T);
[c_raw,lags] = xcov(rg_raw,'coeff');
plot(lags(lags>=0), c_raw(lags>=0),'k-','LineWidth',2);
% plot(0:length(rg_raw)-1,autocorr(rg_raw,length(rg_raw)-1),'b.-','LineWidth',2);
ylabel('ACF (Gravity)'),set(gca,'fontsize',15,'fontweight','bold')
% legend('autocorrelation of standardized residuals','autocorrelation of raw residuals')
xticklabels(h1,[]);
text(13,0.85,'(a)','FontSize',20,'fontweight','bold')

pos2 = [left bottom-0.25 width height];
h2=subplot('Position',pos2);
plot(lags(lags>=0), cTmean(lags>=0),'k--','LineWidth',2);
hold on
[c_raw,lags] = xcov(rT_raw,'coeff');
plot(lags(lags>=0), c_raw(lags>=0),'k-','LineWidth',2);
% plot(0:length(rT_raw)-1,autocorr(rT_raw,length(rT_raw)-1),'b.-','LineWidth',2);
ylabel('ACF (Magnetic)'),xlabel('lag'),set(gca,'fontsize',15,'fontweight','bold')
% legend('autocorrelation of standardized residuals','autocorrelation of raw residuals')
text(13,0.85,'(b)','FontSize',20,'fontweight','bold')
%%% Plot the Histogram of standardized and raw residuals
left = 0.5;
bottom = 0.55;
width = 0.3;
height = 0.2;
dw = 0.02; % between subplots
dh = 0.02; % between subplots
pos3 = [left bottom width height];
h3=subplot('Position',pos3);
xnormal = (-4:.1:4);
ynormal = normpdf(xnormal,0,1);

plot(xnormal,ynormal,'LineWidth',2), hold on,
histogram(sr_g_mean,10,'Normalization','pdf','DisplayStyle','bar','LineWidth',2,'EdgeColor',[0 0 0],'FaceColor',[0.5 0.5 0.5])
hold on
histogram(rg_raw,10,'LineStyle',':','Normalization','pdf','DisplayStyle','stairs','LineWidth',2,'EdgeColor',[1 0 0])
ylabel('pdf'),set(gca,'fontsize',15,'fontweight','bold'),drawnow
xticklabels(h3,[]);
xlabel(h3,'residuals (mGal)')
set(h3,'xaxisLocation','top')
text(-3.8,2.6,'(c)','FontSize',20,'fontweight','bold')


pos4 = [left bottom-0.25 width height];
h4=subplot('Position',pos4);
plot(xnormal,ynormal,'LineWidth',2), hold on,
histogram(sr_T_mean,10,'Normalization','pdf','DisplayStyle','bar','LineWidth',2,'EdgeColor',[0 0 0],'FaceColor',[0.5 0.5 0.5])
hold on
histogram(rT_raw,10,'LineStyle',':','Normalization','pdf','DisplayStyle','stairs','LineWidth',2,'EdgeColor',[1 0 0])
xlabel('residuals (nT)'),ylabel('pdf'),set(gca,'fontsize',15,'fontweight','bold'),drawnow
% legend('normal distribution','standardized residuals','raw residuals')
text(-3.8,0.9,'(d)','FontSize',20,'fontweight','bold')

figname = 'ACF_Hist_residuals';
set(gcf,'color','w');
img = getframe(gcf);
imwrite(img.cdata, [fullfile(fpath,figname), '.png']);
if ExportEPSFig == 1
    % Save eps Figure
    figname= figname(find(~isspace(figname)));
    print(gcf,'-depsc2','-painters',fullfile(fpath,figname));
end
end