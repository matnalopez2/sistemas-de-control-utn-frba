%
% Test de Kalman: Observabilidad
%
% Un sistema (A,C) es completamente observable si el rango de la matriz de
% observabilidad es igual al orden del sistema n (n = size(A,1)):
%
%   Obs = [   C
%            C*A
%            C*A^2
%             ...
%            C*A^(n-1) ]
%   Es observable  <=>  rank(Obs) = n
%
% Devuelve:
%   - true:  si es observable
%   - false: si no es observable
%

function esObs = esObservable(A, C)
% esObservable  Devuelve true si (A,C) es observable (Kalman), false si no.

    % Chequeo parametros correctos
    [n, n2] = size(A);
    if n ~= n2
        error('A debe ser cuadrada.');
    end
    if size(C,2) ~= n
        error('C debe tener la misma cantidad de columnas que A.');
    end

    O = obsv(A, C);

    if rank(O) == n
        disp('Es observable');
        esObs = true;
    else
        disp('No es observable');
        esObs = false;
    end
end
