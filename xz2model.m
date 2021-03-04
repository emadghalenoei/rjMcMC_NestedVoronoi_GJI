function [DensityMap, SusMap] = xz2model(xv,zv,rho,sus)
global Xn Zn
xv = xv';
zv = zv';
% IDX = knnsearch([xv zv], [Xn(:)  Zn(:)],'Distance','cityblock'); % L1
% IDX = knnsearch([xv zv], [Xn(:)  Zn(:)]); %L2
IDX = knnsearch([xv(4:end)  zv(4:end)], [Xn(:)  Zn(:)]); %L2
% IDX = knnsearch([xv(4:end)  zv(4:end)], [Xn(:)  Zn(:)],'Distance','seuclidean','scale',[1 3]); % Standardized Euclidean distance
density = rho(IDX);
DensityMap=reshape(density,size(Xn));

susceptibility = sus(IDX);
SusMap=reshape(susceptibility,size(Xn));
end