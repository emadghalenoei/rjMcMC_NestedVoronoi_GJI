function PLOT_Model_CI_width(x,z,CI_width,Pos_Salt,fpath,figname)
global x_s y_s x_min x_max y_min y_max
figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
mycolormap = jet;
mycolormap(1,:) =1;
imagesc(x,z,CI_width),cbar=colorbar;
axis square
xlim([x_min x_max])
ylim([z_min z_max])
cbar.Label.String = 'Credible Interval Width';
ax1=gca;
ax1.XAxis.TickLabelRotation = 0;
ax1.XAxis.Exponent = 0;
set(ax1,'fontsize',15)
grid on
grid minor
xticks(ax1,linspace(x_s(1),x_s(end),7))
xtickformat('%.0f')
ax1.XAxis.Exponent = 0;
colormap(mycolormap);
%colormap(flip(parula))
set(gca,'Ydir','reverse')
ylabel('Depth (m)'),xlabel('X profile (m)')
shading interp
hold on
x_pos=Pos_Salt(:,1);
z_pos=Pos_Salt(:,2);
bound = boundary(x_pos,z_pos);
plot(x_pos(bound),z_pos(bound),'color','m','LineWidth',3)
hold on
%%% the second axes (MCMC iterations)
ax2=axes('Position',ax1.Position,'xlim', [x_min,x_max], 'color', 'none',...
'YTick',[],'YColor','none','XColor','k', 'XAxisLocation', 'top');
xticks(ax2,linspace(x_min,x_max,7))
ax2.XAxis.Exponent = 0;
xticklabels(ax2,string(linspace(y_min,y_max,7)))
% xtickformat('%.0f')
ax2.XAxis.TickLabelRotation = 0;
ax2.XAxis.Exponent = 0;
set(ax2,'fontsize',15)
xlabel(ax2,'Y Profile (m)','color','k')
axis square
box(ax1,'off')

% Save Figure 
set(gcf,'color','w');
img = getframe(gcf);
imwrite(img.cdata, [fullfile(fpath,figname), '.png']);
end
