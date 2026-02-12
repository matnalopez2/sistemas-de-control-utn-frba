% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Ejercicio 3
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

Mp = 4.32;
ts = 4;

k1 = 1.4;
k2 = 24.6;

G1 = k1;
G2 = 1 / (s-1);
G3 = 1 / s;
H1 = k2 / (s+10);
H2 = 1;

%% Resolución

chi = utilsMati.disenio_compensadores.factor_amort_desde_sobrepico(Mp)

wn = 4 / (chi * ts)



M1 = feedback(G2, H1);

M = feedback(G1 * M1 * G3, H2)
pzmap(M)

