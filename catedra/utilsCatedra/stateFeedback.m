function [K, An] = stateFeedback(A, B, C, D, PLC)
%STATEFEEDBACK Realimenta un ss.
%   Devuelve la matriz de realimentacion, el preamplificador para ganancia
%   unitaria, el A del ss equivalente.
% A: Matriz de estados.
% B: Matriz de entrada
% C: Matriz de salida
% D: Matriz de transmision directa
% PLC: Polos a lazo cerrado de la planta.
    arguments
        A (:,:) double
        B (:,:) double
        C (:,:) double
        D (:,:) double
        PLC double
    end
    n = size(A,1);   % cant estados
    r = size(B,2);   % cant entradas
    m = size(C,1);   % cant salidas

    %%% Controlabilidad
    if ( n > rank(ctrb(A,B)) )
        error('El sistema NO ES controlable. No se puede realimentar el vector de estados\n');
    else
        fprintf('El sistema ES controlable\n');
    end
    
    %%% Realimentacion de vector de estados
    if r == 1 && m == 1
        K = acker(A,B,PLC);
    else
        K = place(A,B,PLC);
    end

    An = A-B*K;

    if nargout == 0
        fprintf('Matriz de realimentación:');
        disp(K);
    end
end