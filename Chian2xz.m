function [xz, rho, sus]= Chian2xz(Chain)
Nnode = Chain(1,2);
x = Chain(1,5:4+Nnode);
z = Chain(1,5+Nnode:4+2*Nnode);
rho = Chain(1,5+2*Nnode:4+2*Nnode+length(x)-3);
sus = Chain(1,5+2*Nnode+length(x)-3:4+2*Nnode+length(x)-3+length(x)-3);
xz = [x;z];
end