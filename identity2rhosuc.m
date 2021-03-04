function [rho,sus] = identity2rhosuc(identity)
global rho_salt_min rho_salt_max rho_basement_min rho_basement_max sus_basement_min sus_basement_max sus_salt_min sus_salt_max

rho = zeros(size(identity));
sus = zeros(size(identity));
rho_salt = rho_salt_min+rand(size(identity))*(rho_salt_max-rho_salt_min);
sus_salt = sus_salt_min+rand(size(identity))*(sus_salt_max-sus_salt_min);
rho_basement = rho_basement_min+rand(size(identity))*(rho_basement_max-rho_basement_min);
sus_basement = sus_basement_min+rand(size(identity))*(sus_basement_max-sus_basement_min);

salt = identity == 2;
basement = identity == 3;

rho = (1-salt).*rho + (salt).* rho_salt;
rho = (1-basement).*rho + (basement).* rho_basement;

sus = (1-salt).*sus + (salt).* sus_salt;
sus = (1-basement).*sus + (basement).* sus_basement;

end
