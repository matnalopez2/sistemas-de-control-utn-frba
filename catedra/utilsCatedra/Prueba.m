clc; clear; close all;

%% Análisis de Condición de Fase para tener un polo en X:

polos = [0 -2 -3];     % tres polos en el eje real
ceros = [];            % ningún cero aún
x = -1 + 1j;           % punto en el plano complejo

[ang, cero] = anguloCero(polos, ceros, x);

%% Descripción de la planta:
A = [-1, -2;-1, 0];
B = [2;0];
C = [0, 1];
D = [0];
planta = ss(A,B,C,D);

%% Realimentación de Vector de Estados:
PLC = [-5, -50];

r_inf = [2]; % Entrada en infinito deseada
y_inf = [4]; % Salida en infinito deseada
[K, Go,~,~] = control(A,B,C,D,PLC, Rinf=r_inf, Yinf=y_inf);

An = A-B*K;
M = ss(An, B, C, D);
M_tot = Go * M; % Sistema Realimentado

%% Estimación del Vector de Estados:
Pest = [-20 -21];
[K, Go, Ke, Goo] = control(A,B,C,D, PLC, Pest=Pest, Rinf=r_inf, Yinf=y_inf);

%% Simulink:

% Caso 1:
%[Aest, Best, Cest, Dest] = caso1(A, B, C, Ke);
% Resolver en SIMULINK

% Caso 2:
%[Aest, Best, Cest, Dest] = caso2(A, B, C, Ke);
% Resolver en SIMULINK

% Caso 4:
[Aest, Best, Cest, Dest] = caso4(A, B, C, Ke);
% Resolver en SIMULINK
