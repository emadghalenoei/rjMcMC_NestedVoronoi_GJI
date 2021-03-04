function [rho,sus] = identity2rhosuc_loop(identity)
global rho_salt_min rho_salt_max rho_basement_min rho_basement_max sus_basement_min sus_basement_max sus_salt_min sus_salt_max
rho = zeros(size(identity));
sus = zeros(size(identity));
for inode = 1:length(identity)
    if identity(inode) == 1
        rho(inode) = 0;
        sus(inode) = 0;
    elseif identity(inode) == 2
        rho(inode) = rho_salt_min+rand(1)*(rho_salt_max-rho_salt_min);
        sus(inode) = sus_salt_min+rand(1)*(sus_salt_max-sus_salt_min);
    elseif identity(inode) == 3
        rho(inode) = rho_basement_min+rand(1)*(rho_basement_max-rho_basement_min);
        sus(inode) = sus_basement_min+rand(1)*(sus_basement_max-sus_basement_min);
    end
end
end