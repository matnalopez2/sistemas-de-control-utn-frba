function [angPolo, posPolo] = anguloPolo(polos, ceros, x)
%ANGULOPOLO Calcula el MF para una posición especifica.
%   Entrega la posición y ángulo que debería tener un polo para que x
%   pertenezca al lugar de raices.
% polos: vector con posiciones de polos en el plano s.
% ceros: vector con posiciones de ceros en el plano s.
% x: punto en el que quiero cumplir condición de fase.
    
    polos = polos(:);
    ceros = ceros(:);

    angle_polos = sum(angle(x-polos));   
    angle_ceros = sum(angle(x-ceros));

    fase_tot = angle_ceros - angle_polos;
    fase_tot = mod(fase_tot + pi, 2*pi) - pi;
    fase_tot = rad2deg(fase_tot);
    
    angPolo = fase_tot - 180;   % Cond. Fase
    
    if angPolo < 0                  % Resultado positivo
        angPolo = angPolo + 360;
    end

    if angPolo > 180    % Resultado imposible
        angPolo = NaN;
        fprintf("No existe cero real que pueda aportar %.2f°.\n", angCero);
    else
        angPolo = real(x) - imag(x)/tan(deg2rad(angPolo));
    end

    fprintf('Fase máxima de cero: %.2f°\n', rad2deg(angle(x)));
    fprintf('Fase neta en x = %.2f°\n', fase_tot);
    fprintf('Cero debería aportar: %.2f°\n', angPolo);
    fprintf('Cero debería estar en: %.2f\n', posPolo);
end