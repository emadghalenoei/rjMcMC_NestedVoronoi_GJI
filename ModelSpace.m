function [DISMODEL,X,Y,Z] = ModelSpace(xs_dg,ys_dg,Z0,ZEND,dZ,Pad_Length)
Azimuth = atan2(xs_dg(end)-xs_dg(1),ys_dg(end)-ys_dg(1));
dis = sqrt((xs_dg-xs_dg(1,1)).^2 + (ys_dg-ys_dg(1,1)).^2);
z=Z0+dZ/2:dZ:ZEND;
N = ceil(length(z)/length(dis));
deltaDis = abs((dis(2)-dis(1))/(N-1));
N = ceil((dis(end)-dis(1))/deltaDis);
pad_num = ceil(Pad_Length/deltaDis);

x = zeros(1,N+(2*pad_num));
y = zeros(1,N+(2*pad_num));
dismodel = zeros(1,N+(2*pad_num));

x(1) = xs_dg(1) - pad_num*deltaDis*sin(Azimuth);
y(1) = ys_dg(1) - pad_num*deltaDis*cos(Azimuth);
dismodel(1) = dis(1) - pad_num*deltaDis;
for i = 1:N+(2*pad_num)
    x(i) = x(1)+(i-1)*deltaDis*sin(Azimuth);
    y(i) = y(1)+(i-1)*deltaDis*cos(Azimuth);
    dismodel(i) = dismodel(1) +(i-1)*deltaDis;
end

[X,Z]=meshgrid(x,z); % include coordinates of center of the blocks
[Y,Z]=meshgrid(y,z); % include coordinates of center of the blocks
[DISMODEL,Z]=meshgrid(dismodel,z); % include coordinates of center of the blocks

end