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

PLC = [-2+2*sqrt(3)*i -2-2*sqrt(3)*i -12]
G = 1/(s*(s+1)*(s+2))
[numG, denG] = tfdata(G, 'v');


%% Resolución

[A, B, C, D] = tf2ss(numG, denG)

K = acker(A, B, PLC)

An = A - B*K
PLC_d=eig(An)