function PLOT_BestChain_Density_and_Sus(Chain,fpath,figname,fignum)
global z_min z_max Xn Zn x_min x_max y_min y_max ExportEPSFig rho_salt_min rho_basement_max
% colormap_3 = [ 0 1 1;1 1 1;0.75 0.75 0.75];
Chain_maxL = topkrows(Chain,1,'descend');
[xz, rho, sus] = Chian2xz(Chain_maxL);
[DensityMap, SusMap] = xz2model(xz(1,:),xz(2,:),rho,sus);
% model(model>0)=1;
% model(model<0)=-1;
figure('units','normalized','outerposition',[0 0 1 1],'visible','on');
left = 0.1;
bottom = 0.3;
width = 0.4;
height = 0.6;
pos1 = [left bottom width height];
h1=subplot('Position',pos1);
imagesc(Xn(1,:),Zn(:,1),DensityMap);
colormap(h1,bluewhitered);
cbar1=colorbar(h1,'horiz');
cbar1.Label.String = 'Density Contrast (g/cm^{3})';
set(cbar1, 'Position',[0.1 0.15 0.4 0.03]);

hold on
plot(xz(1,4:end),xz(2,4:end),'bx','MarkerSize',8);
hold on
plot(xz(1,1:3),xz(2,1:3),'ro','MarkerSize',8,'MarkerFaceColor','red');
hold on
text(xz(1,:),xz(2,:),num2cell(1:length(xz(1,:))),'FontSize',15)
hold on
[vx,vy] = voronoi(xz(1,4:end),xz(2,4:end));
plot(vx,vy,'k-','LineWidth',2);
hold on
[vx_mother,vz_mother] = voronoi(xz(1,1:3),xz(2,1:3));
plot(vx_mother,vz_mother,'r-','LineWidth',2);
set(h1,'Ydir','reverse')
hold on
ylabel('Depth (km)')
xlabel('X Profile (km)')
xtickangle(0)
xticks(h1,linspace(0,1,6));
h1.XAxis.Exponent = 0;
Xticks = round(linspace(x_min,x_max,6)/1000,2);
xticklabels(h1,string(Xticks))
yticks(h1,linspace(0,1,6));
h1.YAxis.Exponent = 0;
Zticks = round(linspace(z_min,z_max,6)/1000,2);
yticklabels(h1,string(Zticks))
set(h1,'fontsize',10,'fontweight','bold')
text(0.9,0.05,'(a)','FontSize',20,'fontweight','bold')
%%% the second axes
ax1=axes('Position',h1.Position,'xlim', [0, 1], 'color', 'none',...
    'YTick',[],'YColor','none','XColor','k', 'XAxisLocation', 'top');
xticks(ax1,linspace(0,1,6));
ax1.XAxis.Exponent = 0;
Yticks = round(linspace(y_min,y_max,6)/1000,2);
xticklabels(ax1,string(Yticks))
set(ax1,'fontsize',10,'fontweight','bold')
xlabel(ax1,'Y Profile (km)','color','k');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pos2 = [left+0.45 bottom width height];
h2=subplot('Position',pos2);
imagesc(Xn(1,:),Zn(:,1),SusMap);
WhiteBlueGreenYellowRed = load('WhiteBlueGreenYellowRed.txt');
colormap(h2,WhiteBlueGreenYellowRed);
cbar2=colorbar(h2,'horiz');
cbar2.Label.String = 'Susceptibility (SI)';
set(cbar2, 'Position',[left+0.45 0.15 0.4 0.03]);
cbar2.Ruler.Exponent = 0;

hold on
plot(xz(1,4:end),xz(2,4:end),'bx','MarkerSize',8);
hold on
plot(xz(1,1:3),xz(2,1:3),'ro','MarkerSize',8,'MarkerFaceColor','red');
hold on
text(xz(1,:),xz(2,:),num2cell(1:length(xz(1,:))),'FontSize',15)
hold on
[vx,vy] = voronoi(xz(1,4:end),xz(2,4:end));
plot(vx,vy,'k-','LineWidth',2);
hold on
[vx_mother,vz_mother] = voronoi(xz(1,1:3),xz(2,1:3));
plot(vx_mother,vz_mother,'r-','LineWidth',2);
set(h2,'Ydir','reverse')
hold on
xlabel('X Profile (km)')
xtickangle(0)
xticks(h2,linspace(0,1,6));
h2.XAxis.Exponent = 0;
xticklabels(h2,string(Xticks))
yticks(h2,linspace(0,1,6));
h2.YAxis.Exponent = 0;
yticklabels(h2,[]);
set(gca,'fontsize',10,'fontweight','bold')
drawnow
text(0.9,0.05,'(b)','FontSize',20,'fontweight','bold')
%%% the second axes
ax2=axes('Position',h2.Position,'xlim', [0, 1], 'color', 'none',...
    'YTick',[],'YColor','none','XColor','k', 'XAxisLocation', 'top');
xticks(ax2,linspace(0,1,6));
ax2.XAxis.Exponent = 0;
xticklabels(ax2,string(Yticks))
set(ax2,'fontsize',10,'fontweight','bold')
xlabel(ax2,'Y Profile (km)','color','k');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% saveas(gca, fullfile(fpath, strcat(figname,num2str(fignum))), 'png');
% Save Figure
set(gcf,'color','w');
img = getframe(gcf);
imwrite(img.cdata, [fullfile(fpath,strcat(figname,num2str(fignum))), '.png']);
if ExportEPSFig == 1
    % Save eps Figure
    figname= figname(find(~isspace(figname)));
    print(gcf,'-depsc2','-painters',fullfile(fpath,strcat(figname,num2str(fignum))));
end
end