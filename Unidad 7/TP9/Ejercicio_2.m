% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Ejercicio 2 - Guía de TP 9
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

A = [0, 1; -27, -5];
B = [1, 1; 0, 1];
C = [1, 0; 0, 1];
D = [0, 0; 0, 0];


%% Resolución

syms s;
Y = C*inv(s*eye(2)-A)*B+D;
simplify(Y)

