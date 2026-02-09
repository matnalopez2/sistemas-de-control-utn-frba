function MP = damping2overshoot(epsilon)
%DAMPING2OVERSHOOT Pasa de factor de amortiguamiento a overshoot (%)
% epsilon: factor de amortiguamiento (0 < epsilon < 1)
    arguments
        epsilon (1,1) double {mustBeGreaterThan(epsilon,0), mustBeLessThan(epsilon,1)}
    end
    MP = 100 * exp(-(epsilon*pi)/sqrt(1 - epsilon^2));
end
