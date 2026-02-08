% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Ejercicio 1 - Guía de TP 9
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

G = tf([23.45 7.18], [1 6.25 28.32 7.18])


%% Resolución

[numG,denG] = tfdata(G, 'v');

[A, B, C, D] = tf2ss(numG, denG)

