% 
% Fórmula para calcular si es controlable, analizado por método de Kalman
% 
%   Se considera controlable cuando el rango de la matriz controlabilidad
%   es igual al rango de la matriz A
% 
% Devuelve:
%   - true: si es controlable
%   - false: si no es controlable

function esCtrb = esControlable(A, B)
% esControlable  Devuelve true si (A,B) es controlable (Kalman), false si no.

    % Chequeo parametros correctos
    [n, n2] = size(A);
    if n ~= n2
        error('A debe ser cuadrada.');
    end
    if size(B,1) ~= n
        error('B debe tener la misma cantidad de filas que A. ¿Está traspuesta?');
    end

    C = ctrb(A, B);

    if( rank(C) == n)
        disp('Es controlable\n');
        esCtrb = true;
    else 
        disp('No es controlable\n');
        esCtrb = false;
    end
end
