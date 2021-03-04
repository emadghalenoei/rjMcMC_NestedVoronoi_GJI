function A = Gravity_Kernel_Expanded(X,Z,x_s)
% Density of basement and salt dome are assumed to be 2.8 and 2.2 g/cm3
% while background rocks set to have 2.6 g/cm3 density.
% Susceptibility of basement rocks is assumed to be 0.004 SI.

% x_s=X(1,:);  % x coordinate for ground stations
% x_s=(x_s)-min(x_s);
%model space
dz=abs(Z(2,1)-Z(1,1));  % thickness of prisms
dx=abs(X(1,2)-X(1,1));  % Prisms dimension along x

%%% Input
cGrav = 6.67408e-11;  % Konstanta Gravitasi (m^3 kg^-1 s^-2)
CX = size(X,2);   % Prisms along x
CZ = size(Z,1);   % Prisms along z
CTOT=CX*CZ; % Total number of prisms

A=ones(length(x_s),CTOT);
Ximat=diag(x_s)*A; % check it
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

teta1=atan2(Xplus,Zminus);
teta2=atan2(Xplus,Zplus);
teta3=atan2(Xminus,Zminus);
teta4=atan2(Xminus,Zplus);

%%%%%%% Synthetic anomaly of prisms
at=log((r2.*r3)./(r1.*r4));
A=2.*cGrav.*((Xplus.*at)+(2.*shiftx).*log(r4./r3)-(Zplus).*(teta4-teta2)+(Zminus).*(teta3-teta1));      
end

