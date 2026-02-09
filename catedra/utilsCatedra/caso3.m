function [Aest, Best, Cest, Dest] = caso3(A, B, C, D, K, Ke)
%CASO4 Creacion de variables para simulink_caso3
%   Calcula los valores para el caso 3 de realimentación de vector de estados + estimación (CASO 3 SIMULINK).
% A: Matriz de Estados.
% B: Matriz de Entrada.
% C: Matriz de Salida.
% D: Matriz de Transmision Directa.
% K: Matriz de Realimentación de Vector de Estados.
% Ke: Matriz de Estimador.
    r = size(B,2);   % Cant Entradas
    m = size(C,1);   % Cant Salidas

    Aest = (A - Ke*C - B*K);
    Best = Ke;          
    Cest = K;
    Dest = zeros(r);
end