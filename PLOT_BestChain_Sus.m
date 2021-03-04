function PLOT_BestChain_Sus(Chain,fpath,figname,fignum)
global z_min z_max Xn Zn x_min x_max y_min y_max ExportEPSFig sus_salt_min sus_basement_max
% colormap_3 = [ 0 1 1;1 1 1;0.75 0.75 0.75];
Chain_maxL = topkrows(Chain,1,'descend');
[xz, rho, sus] = Chian2xz(Chain_maxL);
[DensityMap, SusMap] = xz2model(xz(1,:),xz(2,:),rho,sus);
% model(model>0)=1;
% model(model<0)=-1;
figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
imagesc(Xn(1,:),Zn(:,1),SusMap), cbar=colorbar;
colormap(jet);
cbar.Label.String = 'susceptibility (SI)';
% b = linspace(-1,1,4); % calculate the points where the colour segments start/end
% c = mean([b(1:end-1);b(2:end)]); % calculate the centers;
% set(cbar, 'YTick', [c(1) c(2) c(3)], 'YTickLabel', {'Salt','Sediment','Basement'});
% caxis([salt_density-abs(salt_density/2) basement_density+abs(basement_density/2)])
caxis([sus_salt_min sus_basement_max])
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
axis square
set(gca,'Ydir','reverse')
hold on
ylabel('Depth (m)')
xlabel('X Profile (m)')
xtickangle(0)
ax1 = gca;
xticks(ax1,linspace(0,1,6));
ax1.XAxis.Exponent = 0;
Xticks = round(linspace(x_min,x_max,6),2);
xticklabels(ax1,string(Xticks))
yticks(ax1,linspace(0,1,6));
ax1.YAxis.Exponent = 0;
Yticks = round(linspace(z_min,z_max,6),2);
yticklabels(ax1,string(Yticks))
set(gca,'fontsize',10,'fontweight','bold')
drawnow
%%% the second axes
ax2=axes('Position',ax1.Position,'xlim', [0, 1], 'color', 'none',...
    'YTick',[],'YColor','none','XColor','k', 'XAxisLocation', 'top');
xticks(ax2,linspace(0,1,6));
ax2.XAxis.Exponent = 0;
Yticks = round(linspace(y_min,y_max,6),2);
xticklabels(ax2,string(Yticks))
set(ax2,'fontsize',10,'fontweight','bold')
xlabel(ax2,'Y Profile (m)','color','k');
axis square


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