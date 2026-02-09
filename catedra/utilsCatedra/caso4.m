function [Aest, Best, Cest, Dest] = caso4(A, B, C, Ke)
%CASO4 Creacion de variables para simulink_caso4
%   Calcula los valores para el caso 4 de realimentación de vector de estados + estimación (CASO 4 SIMULINK).
% A: Matriz de Estados.
% B: Matriz de Entrada.
% C: Matriz de Salida.
% D: Matriz de Transmision Directa.
% K: Matriz de Realimentación de Vector de Estados.
% Ke: Matriz de Estimador.
    n = size(A,1);   % Cant Estados
    
    Aest = (A - Ke*C);
    Best = [B Ke];          % Entradas del estimador: [u ; y]
    Cest = eye(n);
    Dest = zeros(size(Best,1), size(Best,2));    
end

    % Planta realimentada G y H
    % Aest = (A-Ke*C-B*K*Ke);
    % Best = Ke;          
    % Cest = K;
    % Dest = zeros(cant_salidas, cant_entradas);
    % 
    % G = ss(A,B,C,D);
    % H = ss(Aest,Best,Cest,Dest);
    % M = feedback(G,H);
    % Goo = 1/dcgain(M);
