function [epsilon] = overshoot2damping( MP )
%OVERSHOOT2DAMPING Pasa de sobrepico a factor de amortiguamiento.
% MP: Porcentual Overshoot
    arguments
        MP (1,1) double {mustBeGreaterThan(MP,0), mustBeLessThan(MP,100)}
    end
    epsilon = 1/(sqrt(1+(pi/log(100/MP))^2));
end

