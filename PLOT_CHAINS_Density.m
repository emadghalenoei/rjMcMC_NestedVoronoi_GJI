function PLOT_CHAINS_Density(Chain,fpath,figname,fignum)
global x_min x_max z_min z_max  Xn Zn rho_salt_min rho_basement_max 
% colormap_3 = [ 0 1 1;1 1 1;0.75 0.75 0.75];
figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
if size(Chain,1) == 4
    a1 = 2;
    a2 = 2;
elseif size(Chain,1) == 8
    a1 = 2;
    a2 = 4;
elseif size(Chain,1) == 10
    a1 = 2;
    a2 = 5;
elseif size(Chain,1) == 12
    a1 = 3;
    a2 = 4;
elseif size(Chain,1) == 14
    a1 = 2;
    a2 = 7;
elseif size(Chain,1) == 16
    a1 = 4;
    a2 = 4;
elseif size(Chain,1) == 20
    a1 = 4;
    a2 = 5;
elseif size(Chain,1) == 25
    a1 = 5;
    a2 = 5;
end
plotnum = 0;
for i=1:size(Chain,1)
    plotnum = plotnum+1;
    [xz, rho, sus] = Chian2xz(Chain(i,:));
    [DensityMap, SusMap] = xz2model(xz(1,:),xz(2,:),rho,sus);
    
%     model(model>0)=1;
%     model(model<0)=-1;
    subplot(a1,a2,plotnum)
    imagesc(Xn(1,:),Zn(:,1),DensityMap);cbar=colorbar; colormap(jet);
%     b = linspace(-1,1,4); % calculate the points where the colour segments start/end
%     c = mean([b(1:end-1);b(2:end)]); % calculate the centers;
%     set(cbar, 'YTick', [c(1) c(2) c(3)],'YTickLabel',[]);
    caxis([rho_salt_min rho_basement_max])
    hold on
    plot(xz(1,4:end),xz(2,4:end),'bx','MarkerSize',2);
    hold on
    plot(xz(1,1:3),xz(2,1:3),'ro','MarkerSize',5,'MarkerFaceColor','red');
    hold on
    [vx,vy] = voronoi(xz(1,4:end),xz(2,4:end));
    plot(vx,vy,'k-','LineWidth',1);
    hold on
    [vx_mother,vz_mother] = voronoi(xz(1,1:3),xz(2,1:3));
    plot(vx_mother,vz_mother,'r-','LineWidth',1.5);
    axis square
    ax = gca;
    set(ax,'Ydir','reverse')
    xticks(ax,linspace(0,1,6));
    ax.XAxis.Exponent = 0;
    Xticks = linspace(x_min,x_max,6);
    xticklabels({})
    %     xticklabels(ax,string(Xticks))
    yticks(ax,linspace(0,1,6));
    ax.YAxis.Exponent = 0;
    Yticks = round(linspace(z_min,z_max,6),2);
    yticklabels(ax,string(Yticks))
    hold on
    drawnow
end
drawnow
set(gcf,'color','w');
img = getframe(gcf);
imwrite(img.cdata, [fullfile(fpath,strcat(figname,num2str(fignum))), '.png']);
end