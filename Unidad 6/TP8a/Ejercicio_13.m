% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Ejercicio 13 - Guía de TP 8a
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

G = 1 / (s*(s+1)*(s+4))

Mp = 15;    % Overshoot < 15%
ts = 1;     % Tiempo de establecimiento < 1 segundo
MG = 3;     % Margen de ganancia > 3dB

polos = pole(G);


%% Resolución

% Defino PLC = -4 +- 4i para asegurar cumplir Mp y ts

% chi = utils.disenio_compensadores.factor_amort_desde_sobrepico(Mp)
chi = utils.disenio_compensadores.factor_amort_desde_sobrepico(4.32)

% ts = 4 / (wn*chi)
wn = 4 / (chi*ts)

w0 = wn * sqrt(1-chi^2)

% chi = cos alfa -> alfa = arc cos chi
alfa = acosd(chi)

% tan alfa = opuesto / adyacente
a = w0 / tand(alfa)

PLC = - a + w0*i




fprintf("Calculo el angulo para el primer polo en %d", polos(1))
delta = angle(PLC - polos(1))*180/pi

fprintf("Calculo el angulo para el segundo polo en %d", polos(3))
beta = angle(PLC - polos(3))*180/pi

fprintf("Calculo el angulo para el tercer polo en %d", polos(2))
gamma = angle(PLC - polos(2))*180/pi


MF = delta + beta + gamma

MF2 = (MF + delta - 180)
% epsilon = (MF - 180)
% z = imag(PLC)/tand(epsilon) - real(PLC)



Gc = 1

rlocus(G*Gc)

% margin(G*Gc)

