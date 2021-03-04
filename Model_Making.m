function [TrueDensityModel, TrueSUSModel] = Model_Making()
global X Z
A = [6.463e05, 10000];
B = [A(1), 9000];
C = [6.657e05, B(2)];
D = [C(1), A(2)];
Polyy = [A; B; C; D];
Polyy = polygon_maker(Polyy);
[base1,on] = inpolygon(X,Z,Polyy(:,1), Polyy(:,2));
density1=double(base1)*0.2;
sus1=double(base1)*0.006;

E = [6.97e05, 9000];
F = [E(1), 10000];
Polyy = [C; D; E; F];
Polyy = polygon_maker(Polyy);
[base2,on] = inpolygon(X,Z,Polyy(:,1), Polyy(:,2));
density2=double(base2)*0.4;
sus2=double(base2)*0.007;

G = [7.142e05, 9000];
H = [G(1), 10000];
Polyy = [E; F; G; H];
Polyy = polygon_maker(Polyy);
[base3,on] = inpolygon(X,Z,Polyy(:,1), Polyy(:,2));
density3=double(base3)*0.3;
sus3=double(base3)*0.006;

I = [mean([B(1),C(1)]), B(2)];
J = [I(1), 8000];
K = [mean([C(1),E(1)]), 8000];
L = [ K(1), 9000];
Polyy = [I; J; K; L];
Polyy = polygon_maker(Polyy);
[base4,on] = inpolygon(X,Z,Polyy(:,1), Polyy(:,2));
density4=double(base4)*0.35;
sus4=double(base4)*0.005;


M = [mean([E(1),G(1)]), 8000];
N = [ M(1), 9000];
Polyy = [K; L; M; N];
Polyy = polygon_maker(Polyy);
[base5,on] = inpolygon(X,Z,Polyy(:,1), Polyy(:,2));
density5=double(base5)*0.3;
sus5=double(base5)*0.007;

O = [ G(1), 7000];
P = [mean([J(1),K(1)]), 7000];
Q = [ K(1)-10000, 8000];
R = [E(1), 8000];
R2 = [K(1), 5000];
Polyy = [O; P; Q; R; R2];
Polyy = polygon_maker(Polyy);
[salt1,on] = inpolygon(X,Z,Polyy(:,1), Polyy(:,2));
density6=double(salt1)*-0.2;

S = [C(1), 4000];
T = [J(1)+1000, J(2)];
Polyy = [P; Q; S; T];
Polyy = polygon_maker(Polyy);
[salt2,on] = inpolygon(X,Z,Polyy(:,1), Polyy(:,2));
density7=double(salt2)*-0.35;

TrueDensityModel = density1 + density2 + density3 + density4 + density5 + density6 + density7;
TrueSUSModel = sus1 + sus2 + sus3 + sus4 + sus5;
end
