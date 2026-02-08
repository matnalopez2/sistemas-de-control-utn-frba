% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Ejercicio 3 - Guía de TP 9
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Inicialización

% Generales
clear; clc; close all;
s = tf('s');

% Para gráficos
T_inicio    = 0;
delta_t     = 0.01;
T_final     = 8;
t           = (T_inicio:delta_t:T_final)';


%% Datos del problema

PLC = [-0.8+1.1i -0.8-1.1*i -5]
G = 0.1/((s+0.5)*(s+0.1)*(s+2))
[numG, denG] = tfdata(G, 'v');


%% Resolución

[A, B, C, D] = tf2ss(numG, denG)

figure; step(G)

K = acker(A, B, PLC)
An = A - B*K
PLC_d=eig(An)

kr = 1/(C*inv(-A+B*K)*B)

sys = ss(An, kr*B, C, D);
figure; step(sys)