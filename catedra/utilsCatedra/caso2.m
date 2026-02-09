function [Aest, Best, Cest, Dest] = caso2(A, B, C, Ke)
%CASO2 Creacion de variables para simulink_caso2
% Calcula los valores para el caso 2 de realimentación de vector de estados + estimación (CASO 2 SIMULINK).
% A: Matriz de Estados.
% B: Matriz de Entrada.
% C: Matriz de Salida.
% Ke: Matriz de Estimación.
    n = size(A,1);   % Cant Estados
    r = size(B,2);   % Cant Entradas
    m = size(C,1);   % Cant Salidas

    Aest = A;
    Best = [B Ke];          % Entradas del estimador: [u ; y]
    Cest = eye(n);
    Dest = zeros(n, (m + r));
end