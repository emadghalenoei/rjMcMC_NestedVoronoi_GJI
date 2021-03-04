function step= select_step_404020(Nnode)
global Kmin Kmax
r = rand();
    if Nnode==Kmin % go only for birth and move
        if r <= 0.8
            step = 91; %birth
        else
            step = 93; %move
        end
    elseif Nnode==Kmax % go only for death and move
        if r <= 0.8
            step = 92; %death
        else
            step = 93; %move
        end
    else
        if r <= 0.4
            step = 91; %birth
        elseif r > 0.4 && r <= 0.8
            step = 92; %death
        else
            step = 93; %move
        end
    end
end