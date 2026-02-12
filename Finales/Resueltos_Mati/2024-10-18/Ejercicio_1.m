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

G = 6 / (s+1)^3



%% Resolución


% margin(G)

% rlocus(G)

PLC = -1 + 1i;

alfa = angle(PLC - (-1))*180/pi
gamma = angle(PLC - (0))*180/pi


MF = 3*alfa + gamma


gamma = (180 - MF) / 2
 
gama_p = 180 + gamma
a = real(PLC) / tand(gama_p)
z = real(PLC) - a
Gc = ((s+z)^2)/s;
rlocus(G*Gc)
[k, polos] = rlocfind(Gc*G, PLC)


