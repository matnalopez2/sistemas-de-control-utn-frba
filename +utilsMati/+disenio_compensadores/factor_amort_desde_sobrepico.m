% 
% Fórmula para calcular el factor de amortiguamiento
% 

function chi = factor_amort_desde_sobrepico(Mp)
    chi = 1 / sqrt(1 + ((pi/(log(Mp/100)))^2));
end






