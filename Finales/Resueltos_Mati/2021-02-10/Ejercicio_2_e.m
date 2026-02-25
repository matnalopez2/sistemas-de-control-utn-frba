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

H = 1;

numG = 2;
denG = (s*s + 4*s + 2);

G = numG/denG
polos = pole(G)

%% Resolución

PLC = -4 + 4i;

gamma = angle(PLC - polos(1))*180/pi
delta = angle(PLC - polos(2))*180/pi
beta  = angle(PLC - 0)*180/pi

MF = gamma + delta + beta

tita = MF - 180
alfa = tita/2

a = 4 / tand(alfa)

z = 4 + a

% Gc = ((s + z)^2) / s;
% Gc = (s+7.5)/s;
Gc = (s+4.35)*(s+3.41)/s;

rlocus(Gc*G)
[k, polos] = rlocfind(Gc*G, PLC)

kD = k
kI = (4.35*3.41)*kD
kP = (4.35+3.41)*kD

Gc2 = kP + kD*s + kI/s;

M = feedback(Gc2*G, H)
pole(M)
