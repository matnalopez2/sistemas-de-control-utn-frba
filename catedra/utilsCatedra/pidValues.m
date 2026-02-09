function [KP,KD,KI] = pidValues(K, polos, ceros)
% PIDVALUES Obtiene KP, KI, KD a partir de ceros y polos del controlador
%   K  : ganancia escalar del controlador
%   z  : ceros del controlador (vector fila o columna)
%   p  : polos del controlador (vector fila o columna)
%
% Controladores admitidos:
%   - P
%   - I    (1 polo en 0)
%   - PI   (1 polo y 1 polo en 0)
%   - PD   (1 cero)
%   - PID  (1 cero y 1 polo en 0)
    arguments
        K (1,1) double
        polos (:,1) double = []
        ceros (:,1) double = []
    end

    ceros = ceros(:)';
    polos = polos(:)';
    nz = numel(ceros);
    np = numel(polos);

    KP = 0;
    KI = 0;
    KD = 0;

    if nz == 0 && np == 0       % P     
        KP = K;
    elseif nz == 0 && np == 1 && polos(1) == 0  % I: K * (1 / s)
        KI = K;
    elseif nz == 1 && np == 1 && polos(1) == 0  % PI: K * (s - z)/s
        KP = K;
        KI = -K * ceros(1);
    elseif nz == 1 && np == 0                   % PD: K * (s - z)
        KD = K;
        KP = -K * ceros(1);
    elseif nz == 2 && np == 1 && polos(1) == 0  % PID: K * (s - z1)(s - z2)/s
        KD = K;
        KP = -K * (ceros(1) + ceros(2));
        KI = K * ceros(1) * ceros(2);
    else
        error("Estructura no soportada. Usar: P, I, PI, PD, PID.");
    end
end

