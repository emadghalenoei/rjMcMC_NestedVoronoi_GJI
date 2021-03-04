function A = Mag_Kernel_Expanded(X,Z,x_s,I,Azimuth)
% Density of basement and salt dome are assumed to be 2.8 and 2.2 g/cm3
% while background rocks set to have 2.6 g/cm3 density.
% Susceptibility of basement rocks is assumed to be 0.004 SI.

% x_s=X(1,:);  % x coordinate for ground stations

%model space
dz=abs(Z(2,1)-Z(1,1));  % thickness of prisms
dx=abs(X(1,2)-X(1,1));  % Prisms dimension along x

%%% Input
I=I * (pi/180);    %inclination
%Azimuth=0; %Azimuth of profile = Angle between North and profile
Beta = (90-Azimuth)*pi/180;   % Angle between East and profile (in telford p90, Beta is angle between x(East) and x'(profile))
%Fe=43314; %(nT)
CX = size(X,2);    % Prisms along x
CZ = size(Z,1);   % Prisms along z
CTOT=CX*CZ; % Total number of prisms

A=ones(length(x_s),CTOT);
Ximat=diag(x_s)*A;
Xjmat=A*diag(X(:));
Zjmat=A*diag(Z(:));
shiftx=(dx/2)*A;
shiftz=(dz/2)*A;

Xplus=Ximat-Xjmat+shiftx;
Xminus=Ximat-Xjmat-shiftx;
Zplus=Zjmat+shiftz;
Zminus=Zjmat-shiftz;
Xplus2=Xplus.^2;
Xminus2=Xminus.^2;
Zplus2=Zplus.^2;
Zminus2=Zminus.^2;

% Distance and angles
r1=(Zminus2+Xplus2).^0.5;
r2=(Zplus2+Xplus2).^0.5;
r3=(Zminus2+Xminus2).^0.5;
r4=(Zplus2+Xminus2).^0.5;

teta1=atan2(Zminus,Xplus);
teta2=atan2(Zplus,Xplus);
teta3=atan2(Zminus,Xminus);
teta4=atan2(Zplus,Xminus);

% teta1 = teta1+(teta1<0)*(2*pi);
% teta2 = teta2+(teta2<0)*(2*pi);
% teta3 = teta3+(teta3<0)*(2*pi);
% teta4 = teta4+(teta4<0)*(2*pi);
   
%%%%%% Synthetic anomaly of prisms
at=log((r2.*r3)./(r1.*r4));
bt=teta1-teta2-teta3+teta4;
% bt = bt+(bt>pi)*(-2*pi);
% bt = bt+(bt<pi)*(2*pi);
ct=cos(I)^2.*sin(Beta)^2-sin(I)^2;
A=sin(2*I)*sin(Beta).*at+ct.*bt;
end
