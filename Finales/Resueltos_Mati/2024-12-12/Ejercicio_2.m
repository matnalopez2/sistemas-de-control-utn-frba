% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Ejercicio X 
% Realizado por: Matías Nahuel López
% 
% Universidad Tecnológica Nacional
% Facultad Regional de Buenos Aires
% 
% Legajo: 153.327-7
% Contacto: matias@matnalopez.com.ar
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

syms s m1 k1 m2 k2 b

numG1 = [0 0 k1];
denG1 = [m1 0 k1];

G1 = tf(numG1, denG1)

%% Resolución



















