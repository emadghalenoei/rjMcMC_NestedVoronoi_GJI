function PLOT_accpt_rate(acpt_ratio,fpath,figname,fignum)
T1_accp = acpt_ratio(:,:,end)*100;
Tmax_accp = acpt_ratio(:,:,1)*100;
h=figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
subplot(1,2,1)
mycolormap = jet;mycolormap(1,:) =1;colormap(mycolormap);
imagesc(T1_accp),cbar = colorbar; caxis([0 100]), axis square, set(gca,'fontsize',15),
title('T=1')
cbar.Label.String = 'acceptance rate %';
% [nrow, ncol] = size(T1_accp);
% xticks(1:ncol)
% yticks(1:nrow)
% a = get(gca,'YTickLabel');  
% set(gca,'YTickLabel',a,'fontsize',8);

set(gca,'XTick',[], 'YTick', [])
set(gca,'XTickLabel',[]);
set(gca,'YTickLabel',[]);

% xticklabels("k="+(1:ncol));
% yticklabels(["x_"+(1:nrow/3), "z_"+(1:nrow/3), "\rho_{"+(1:nrow/3)+"}"]);
ylabel('Parameters')
xlabel('Node')

subplot(1,2,2)
colormap(mycolormap);
imagesc(Tmax_accp),cbar = colorbar; caxis([0 100]), axis square, set(gca,'fontsize',15),
title('T=Max')
cbar.Label.String = 'acceptance rate %';
[nrow, ncol] = size(Tmax_accp);
% [x_text, y_text] = meshgrid(1:ncol,1:nrow);
% hold on, text(x_text(:)-0.2,y_text(:),num2str(Tmax_accp(:),'%0.2f'),'fontsize',12)
xticks(1:ncol)
yticks(1:nrow)
a = get(gca,'YTickLabel');  
set(gca,'YTickLabel',a,'fontsize',8);
% xticklabels("k="+(1:ncol));
% yticklabels(["x_"+(1:nrow/3), "z_"+(1:nrow/3), "\rho_{"+(1:nrow/3)+"}"]);
ylabel('Parameters')
xlabel('Node')
saveas(h, fullfile(fpath, strcat(figname,num2str(fignum))), 'png');
end