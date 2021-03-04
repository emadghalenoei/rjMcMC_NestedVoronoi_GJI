function PLOT_7subplots(TrueDensityModel,PMD_g,CI_L_g,CI_H_g,TrueSUSModel,PMD_T,CI_L_T,CI_H_T,fpath,figname,fignum)
global Z y_min y_max x_min x_max   dis_intsc   ExportEPSFig dis_min dis_max rho_salt_min rho_basement_max sus_basement_max DISMODEL
figure('units','normalized','outerposition',[0 0 1 1],'visible','on');

fontsize = 12;

left = 0.22;
bottom = 0.1;
width = 0.7;
height = 0.1;
dw = 0.02; % between subplots
dh = 0.02; % between subplots
pos1 = [left bottom width height];
h1=subplot('Position',pos1);

row = [95, 65];
col = [30, 60];

x = DISMODEL(1,:)/1000;
plot(x,PMD_g(row(1),:),'k--','linewidth',2)
hold on
plot(x,CI_L_g(row(1),:),'color',[0.5 0.5 0.5],'linewidth',2)
hold on
plot(x,CI_H_g(row(1),:),'color',[0.5 0.5 0.5],'linewidth',2)
hold on
plot(x,TrueDensityModel(row(1),:),'r.-','linewidth',1,'markersize',8)
ylabel(h1,'Z1: Density Contrast (g/cm^{3})')
ylh = get(h1,'ylabel');
ylp = get(ylh, 'Position');
ylp(1) = ylp(1)-2;
set(ylh, 'Rotation',0, 'Position',ylp, 'VerticalAlignment','middle', 'HorizontalAlignment','right')
% ylim([-0.1 rho_basement_max+0.1])
xlabel('X Profile (km)')
set(h1,'fontsize',fontsize,'fontweight','bold')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pos2 = [left bottom+height+dh width height];
h2=subplot('Position',pos2);

plot(x,PMD_g(row(2),:),'k--','linewidth',2)
hold on
plot(x,CI_L_g(row(2),:),'color',[0.5 0.5 0.5],'linewidth',2)
hold on
plot(x,CI_H_g(row(2),:),'color',[0.5 0.5 0.5],'linewidth',2)
hold on
plot(x,TrueDensityModel(row(2),:),'r.-','linewidth',1,'markersize',8)

ylabel(h2,'Z2: Density Contrast (g/cm^{3})')
ylh = get(h2,'ylabel');
ylp = get(ylh, 'Position');
ylp(1) = ylp(1)-2;
set(ylh, 'Rotation',0, 'Position',ylp, 'VerticalAlignment','middle', 'HorizontalAlignment','right')
% ylim([rho_salt_min-0.1 +0.1])
xticklabels(h2,[]);
set(h2,'fontsize',fontsize,'fontweight','bold')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pos3 = [left bottom+2*(height+dh) width height];
h3=subplot('Position',pos3);

plot(x,PMD_T(row(1),:),'k--','linewidth',2)
hold on
plot(x,CI_L_T(row(1),:),'color',[0.5 0.5 0.5],'linewidth',2)
hold on
plot(x,CI_H_T(row(1),:),'color',[0.5 0.5 0.5],'linewidth',2)
hold on
plot(x,TrueSUSModel(row(1),:),'r.-','linewidth',1,'markersize',8)
h3.YAxis.Exponent = 0;
ylabel(h3,'Z1: Susceptibility (SI)')
ylh = get(h3,'ylabel');
ylp = get(ylh, 'Position');
ylp(1) = ylp(1)-2;
set(ylh, 'Rotation',0, 'Position',ylp, 'VerticalAlignment','middle', 'HorizontalAlignment','right')

% ylim([-2e-03 sus_basement_max])
xticklabels(h3,[]);
set(h3,'fontsize',fontsize,'fontweight','bold')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
left = 0.22;
bottom = 0.5;
width = 0.15;
height = 0.4;
dw = 0.008; % between subplots
dh = 0.02; % between subplots
pos4 = [left bottom width height];
h4=subplot('Position',pos4);

plot(PMD_g(:,col(1)),Z(:,1)/1000,'k--','linewidth',2)
hold on
plot(CI_L_g(:,col(1)),Z(:,1)/1000,'color',[0.5 0.5 0.5],'linewidth',2)
hold on
plot(CI_H_g(:,col(1)),Z(:,1)/1000,'color',[0.5 0.5 0.5],'linewidth',2)
hold on
plot(TrueDensityModel(:,col(1)),Z(:,1)/1000,'r.-','linewidth',1,'markersize',8)
set(h4,'Ydir','reverse')
set(h4,'xaxisLocation','top')
% xlabel('X1: Density Contrast (g/cm^{3})')
xlabel({'X1';'Density Contrast (g/cm^{3})'})
ylabel(h4,'Depth (km)')
ylh = get(h4,'ylabel');
ylp = get(ylh, 'Position');
ylp(1) = ylp(1)-0.2;
set(ylh, 'Rotation',0, 'Position',ylp, 'VerticalAlignment','middle', 'HorizontalAlignment','right')
set(h4,'fontsize',fontsize,'fontweight','bold')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pos5 = [left+0.8*(left+dw) bottom width height];
h5=subplot('Position',pos5);

plot(PMD_g(:,col(2)),Z(:,1)/1000,'k--','linewidth',2)
hold on
plot(CI_L_g(:,col(2)),Z(:,1)/1000,'color',[0.5 0.5 0.5],'linewidth',2)
hold on
plot(CI_H_g(:,col(2)),Z(:,1)/1000,'color',[0.5 0.5 0.5],'linewidth',2)
hold on
plot(TrueDensityModel(:,col(2)),Z(:,1)/1000,'r.-','linewidth',1,'markersize',8)
set(h5,'Ydir','reverse')
set(h5,'xaxisLocation','top')
xlabel({'X2';'Density Contrast (g/cm^{3})'})
yticklabels(h5,[]);
set(h5,'fontsize',fontsize,'fontweight','bold')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pos6 = [left+1.6*(left+dw) bottom width height];
h6=subplot('Position',pos6);

plot(PMD_T(:,col(1)),Z(:,1)/1000,'k--','linewidth',2)
hold on
plot(CI_L_T(:,col(1)),Z(:,1)/1000,'color',[0.5 0.5 0.5],'linewidth',2)
hold on
plot(CI_H_T(:,col(1)),Z(:,1)/1000,'color',[0.5 0.5 0.5],'linewidth',2)
hold on
plot(TrueSUSModel(:,col(1)),Z(:,1)/1000,'r.-','linewidth',1,'markersize',8)
set(h6,'Ydir','reverse')
set(h6,'xaxisLocation','top')
xlabel({'X1';'Susceptibility (SI)'})
h6.XAxis.Exponent = 0;
yticklabels(h6,[]);
set(h6,'fontsize',fontsize,'fontweight','bold')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pos7 = [left+2.4*(left+dw) bottom width height];
h7=subplot('Position',pos7);

plot(PMD_T(:,col(2)),Z(:,1)/1000,'k--','linewidth',2)
hold on
plot(CI_L_T(:,col(2)),Z(:,1)/1000,'color',[0.5 0.5 0.5],'linewidth',2)
hold on
plot(CI_H_T(:,col(2)),Z(:,1)/1000,'color',[0.5 0.5 0.5],'linewidth',2)
hold on
plot(TrueSUSModel(:,col(2)),Z(:,1)/1000,'r.-','linewidth',1,'markersize',8)
set(h7,'Ydir','reverse')
set(h7,'xaxisLocation','top')
xlabel({'X2';'Susceptibility (SI)'})
h7.XAxis.Exponent = 0;
yticklabels(h7,[]);
set(h7,'fontsize',fontsize,'fontweight','bold')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Save Figure
set(gcf,'color','w');
img = getframe(gcf);
figname = strrep(figname,'(g/cm^{3})',[]);
imwrite(img.cdata, [fullfile(fpath,strcat(figname,num2str(fignum))), '.png']);
% Save eps Figure
if ExportEPSFig == 1
    figname= figname(find(~isspace(figname)));
    print(gcf,'-depsc2','-painters',fullfile(fpath,strcat(figname,num2str(fignum))));
end
end
