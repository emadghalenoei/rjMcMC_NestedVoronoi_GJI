function PLOT_3subplots(x,z,PMD1,PMD2,PMD3,fpath,LIMIT,clrmap,figname,fignum)
global y_min y_max x_min x_max   dis_intsc   ExportEPSFig dis_min dis_max rho_salt_min rho_basement_max sus_basement_max
figure('units','normalized','outerposition',[0 0 1 1],'visible','on');

left = 0.1;
bottom = 0.4;
width = 0.25;
height = 0.4;
dw = 0.02; % between subplots
pos1 = [left bottom width height];
h1=subplot('Position',pos1);
x = x/1000; % convert to km
z = z/1000; % convert to km
imagesc(x,z,PMD1)

% axis square
caxis(LIMIT)
colormap(bluewhitered);
% xlim(h1,[dis_min dis_max])
h1.XAxis.TickLabelRotation = 0;
set(h1,'fontsize',15,'fontweight','bold')
Xticks = round(linspace(dis_min-dis_min,dis_max-dis_min,6)/1000,2);
xticks(h1,Xticks);
h1.XAxis.Exponent = 0;
xticklabels(h1,string(Xticks))

Yticks = 0:2:10;
yticks(h1,Yticks);
h1.YAxis.Exponent = 0;
yticklabels(h1,string(Yticks))
ylabel(h1,'Depth (km)'),xlabel(h1,'X Profile (km)')
text(mean(x),z(5),'(a)','FontSize',20,'fontweight','bold')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cbar=colorbar('horiz');
cbar.Label.String = 'Density Contrast (g/cm^{3})';
set(cbar, 'Position',[0.3 0.25 0.4 0.03]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pos2 = [left+width+dw  bottom width height];
h2=subplot('Position',pos2);
imagesc(x,z,PMD2)

% axis square
caxis(LIMIT)
colormap(bluewhitered);
% xlim(h2,[dis_min dis_max])
h2.XAxis.TickLabelRotation = 0;
set(h2,'fontsize',15,'fontweight','bold')
xticks(h2,Xticks);
h2.XAxis.Exponent = 0;
xticklabels(h2,string(Xticks))
yticks(h2,Yticks);
yticklabels(h2,[]);
xlabel(h2,'X Profile (km)')
text(mean(x),z(5),'(b)','FontSize',20,'fontweight','bold')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pos3 = [left+2*(width+dw) bottom width height];
h3=subplot('Position',pos3);
imagesc(x,z,PMD3)

% axis square
caxis(LIMIT)
colormap(bluewhitered);
% xlim(h3,[dis_min dis_max])
h3.XAxis.TickLabelRotation = 0;
set(h3,'fontsize',15,'fontweight','bold')
xticks(h3,Xticks);
h3.XAxis.Exponent = 0;
xticklabels(h3,string(Xticks))
yticks(h3,Yticks);
yticklabels(h3,[]);
xlabel(h3,'X Profile (km)')
text(mean(x),z(5),'(c)','FontSize',20,'fontweight','bold')
%%%%%%%%%
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
