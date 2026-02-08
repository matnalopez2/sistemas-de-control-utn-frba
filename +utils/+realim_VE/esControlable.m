%
% Test de Kalman: Controlabilidad
%
% Un sistema (A,B) es completamente controlable si el rango de la matriz de
% controlabilidad es igual al orden del sistema n (n = size(A,1)):
%
%   Ctrb = [ B  A*B  A^2*B  ...  A^(n-1)*B ]
%   Es controlable  <=>  rank(Ctrb) = n
%
% Devuelve:
%   - true:  si es controlable
%   - false: si no es controlable
%

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
        disp('Es controlable');
        esCtrb = true;
    else 
        disp('No es controlable');
        esCtrb = false;
    end
end
