function PLOT_swap_rate(swap_rate,Temp,fpath,figname,fignum)
h=figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
mycolormap = jet;mycolormap(1,:) =1;colormap(mycolormap);
imagesc(round(swap_rate*100)),cbar = colorbar; caxis([0 100]), axis square, set(gca,'fontsize',15),
cbar.Label.String = 'swap acceptance rate';
[x_text, y_text] = meshgrid(1:size(swap_rate,2),1:size(swap_rate,1));
hold on, text(x_text(:)-0.2,y_text(:),num2str(round(swap_rate(:)*100)),'fontsize',12)
xticks(1:size(swap_rate,2))
yticks(1:size(swap_rate,1))
xticklabels(round(Temp,2));
yticklabels(round(Temp,2));
xtickangle(90)
ylabel('Temperature')
xlabel('Temperature')
saveas(h, fullfile(fpath, strcat(figname,num2str(fignum))), 'png');
end