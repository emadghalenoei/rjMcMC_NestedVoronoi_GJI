function PLOT_6subplots(x,z,PMD1,PMD2,PMD3,PMD4,PMD5,PMD6,fpath,LIMIT,clrmap,figname,fignum)
global y_min y_max x_min x_max   dis_intsc   ExportEPSFig dis_min dis_max rho_salt_min rho_basement_max sus_basement_max
figure('units','normalized','outerposition',[0 0 1 1],'visible','off');

left = 0.2;
bottom = 0.7;
width = 0.25;
height = 0.25;
dw = 0.02; % between subplots
dh = 0.02; % between subplots
pos1 = [left bottom width height];
h1=subplot('Position',pos1);
x = x/1000; % convert to km
z = z/1000; % convert to km
imagesc(x,z,PMD1)

% axis square
caxis(LIMIT)
colormap(h1,bluewhitered)
% colormap(bluewhitered);
% xlim(h1,[dis_min dis_max])
Xticks = round(linspace(dis_min-dis_min,dis_max-dis_min,6)/1000,2);
xticks(h1,Xticks);
h1.XAxis.TickLabelRotation = 0;
set(h1,'fontsize',15,'fontweight','bold')
xticklabels(h1,[]);


Yticks = 0:2:10;
yticks(h1,Yticks);
h1.YAxis.Exponent = 0;
yticklabels(h1,string(Yticks))

ylabel(h1,'Depth (km)')
text(x(5),z(10),'(a)','FontSize',20,'fontweight','bold')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% cbar1=colorbar('vert');
% cbar1.Label.String = 'Density Contrast (g/cm^{3})';
% set(cbar1, 'Position',[0.1 0.4 0.01 0.5]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pos2 = [left  bottom-(height+dh) width height];
h2=subplot('Position',pos2);
imagesc(x,z,PMD2)

row = [95, 65];
col = [30, 60];

hold on
for i=1:length(row)
    yline(z(row(i)),'--k',{strcat('Z',num2str(i))},'LabelVerticalAlignment','middle','linewidth',2,'fontsize',12);
    hold on
end
hold on
for i=1:length(col)
    xline(x(col(i)),'--k',{strcat('X',num2str(i))},'LabelHorizontalAlignment','center','LabelOrientation','horizontal','linewidth',2,'fontsize',12);
    hold on
end

% axis square
caxis(LIMIT)
colormap(h2,bluewhitered)
% xlim(h2,[dis_min dis_max])
h2.XAxis.TickLabelRotation = 0;
set(h2,'fontsize',15,'fontweight','bold')
xticklabels(h2,[]);
xticks(h2,Xticks);

yticks(h2,Yticks);
h2.YAxis.Exponent = 0;
yticklabels(h2,string(Yticks))
ylabel(h2,'Depth (km)')
text(x(5),z(10),'(b)','FontSize',20,'fontweight','bold')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pos3 = [left bottom-2*(height+dh) width height];
h3=subplot('Position',pos3);
imagesc(x,z,PMD3)

% axis square
% caxis(LIMIT)
WhiteBlueGreenYellowRed = load('WhiteBlueGreenYellowRed.txt');
colormap(h3,WhiteBlueGreenYellowRed);
% xlim(h3,[dis_min dis_max])
xticks(h3,Xticks);
xticklabels(h3,string(Xticks))
h3.XAxis.TickLabelRotation = 0;
set(h3,'fontsize',15,'fontweight','bold')

yticks(h3,Yticks);
h3.YAxis.Exponent = 0;
yticklabels(h3,string(Yticks))
xlabel(h3,'X Profile (km)'),ylabel(h3,'Depth (km)')
text(x(5),z(10),'(c)','FontSize',20,'fontweight','bold')
%%%%%%%%%%%%%%%%%%%

cb1 = colorbar(h1,'Position',[left-0.1  bottom-(height+0.02) 0.015 2.1*height]);
cb1.Label.String = 'Density Contrast (g/cm^{3})';
cb2 = colorbar(h3,'Position',[0.1 0.12 0.015 0.28]);
cb2.Label.String = '95% CIs width (g/cm^{3})';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

left = 0.47;
bottom = 0.7;
width = 0.25;
height = 0.25;
dw = 0.02; % between subplots
dh = 0.02; % between subplots
pos4 = [left bottom width height];
h4=subplot('Position',pos4);
imagesc(x,z,PMD4)

% axis square
LIMIT=[0 sus_basement_max];
caxis(LIMIT)
myjet = jet;
myjet(1,:) =1;
% colormap(h4,myjet);
colormap(h4,WhiteBlueGreenYellowRed);
xticks(h4,Xticks);
xticklabels(h4,[]);
h4.XAxis.TickLabelRotation = 0;
set(h4,'fontsize',15,'fontweight','bold')
yticklabels(h4,[]);
text(x(5),z(10),'(d)','FontSize',20,'fontweight','bold')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% cbar1=colorbar('vert');
% cbar1.Label.String = 'Density Contrast (g/cm^{3})';
% set(cbar1, 'Position',[0.1 0.4 0.01 0.5]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pos5 = [left  bottom-(height+dh) width height];
h5=subplot('Position',pos5);
imagesc(x,z,PMD5)

row = [95];
col = [30, 60];

hold on
for i=1:length(row)
    yline(z(row(i)),'--k',{strcat('Z',num2str(i))},'LabelVerticalAlignment','middle','linewidth',2,'fontsize',12);
    hold on
end
hold on
for i=1:length(col)
    xline(x(col(i)),'--k',{strcat('X',num2str(i))},'LabelHorizontalAlignment','center','LabelOrientation','horizontal','linewidth',2,'fontsize',12);
    hold on
end

% axis square
caxis(LIMIT)
% colormap(h5,myjet);
colormap(h5,WhiteBlueGreenYellowRed);
xticks(h5,Xticks);
h5.XAxis.TickLabelRotation = 0;
set(h5,'fontsize',15,'fontweight','bold')
xticklabels(h5,[]);
yticklabels(h5,[]);
text(x(5),z(10),'(e)','FontSize',20,'fontweight','bold')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pos6 = [left bottom-2*(height+dh) width height];
h6=subplot('Position',pos6);
imagesc(x,z,PMD6)

% axis square
% caxis(LIMIT)
colormap(h6,WhiteBlueGreenYellowRed);
caxis(LIMIT)
% xlim(h3,[dis_min dis_max])
h6.XAxis.TickLabelRotation = 0;
xticks(h6,Xticks);
set(h6,'fontsize',15,'fontweight','bold')
xticklabels(h6,string(Xticks))
yticklabels(h6,[]);
xlabel(h6,'X Profile (km)')
text(x(5),z(10),'(f)','FontSize',20,'fontweight','bold')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cb3 = colorbar(h4,'Position',[0.75  0.15 0.015 0.8]);
cb3.Label.String = 'Susceptibility (SI)';
cb3.Ruler.Exponent = 0;
% cb4 = colorbar(h6,'Position',[0.8 0.12 0.01 0.28]);
% cb4.Label.String = '95% CIs width (SI)';

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
