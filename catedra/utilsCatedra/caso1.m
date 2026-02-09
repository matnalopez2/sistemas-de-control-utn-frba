function [Aest, Best, Cest, Dest] = caso1(A, B, C, Ke)
%CASO1 Creacion de variables para simulink_caso1
%   Calcula los valores para el caso 1 de realimentación de vector de estados + estimación (CASO 1 SIMULINK).
% A: Matriz de Estados.
% B: Matriz de Entrada.
% C: Matriz de Salida.
% Ke: Matriz de Estimación.
    n = size(A,1);   % Cant Estados
    r = size(B,2);   % Cant Entradas
    m = size(C,1);   % Cant Salidas

    Aest = (A-Ke*C);
    Best = [B Ke];          % Entradas del estimador: [u ; y]
    Cest = eye(n);
    Dest = zeros(n, (m + r));
end