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

num_G1 = 10;
den_G1 = s*(s+1)*(s+10);

G1 = num_G1 / den_G1;

[numG1, denG1] = tfdata(G1, 'v')


%% Resolución

% Pruebo kt=5.98 
% k = 5.98
% k = 1 + kt
% No me sirve, queda p3=-1,2 siendo dominante

% Pruebo k=2.23
k = 2.23
kt = k - 1
% Si me sirve! Vamos con este

M1 = feedback(G1, kt*s);
[numM1, denM1] = tfdata(M1, 'v')


M = feedback(k*M1, 1);
pzmap(M)



