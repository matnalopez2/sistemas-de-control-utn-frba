% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Ejercicio 3 - Guía de TP 8b
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

G = 1 / (s*(s+1)*(s+10))
G2 = 2 / (s*(s+1)*(s+4))

%% Resolución

k = 4;
G1 = k * G

figure;margin(G1)
figure;margin(G2*20)

