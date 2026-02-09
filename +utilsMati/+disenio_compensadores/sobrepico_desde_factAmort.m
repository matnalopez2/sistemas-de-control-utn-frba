% 
% Fórmula para calcular el factor de amortiguamiento
% 

function Mp = sobrepico_desde_factAmort(chi)
    Mp = 100 * exp(- chi * pi / sqrt(1 - chi^2));
end






