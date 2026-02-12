% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Ejercicio 13 - Guía de TP 8a
% Realizado por: Matías Nahuel López
% 
% Universidad Tecnológica Nacional
% Facultad Regional de Buenos Aires
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
figure; pzmap(G)

%% Resolución

% chi = utilsMati.disenio_compensadores.factor_amort_desde_sobrepico(Mp)
% Reemplazo mi función por lo que realiza internamente por simplicidad para
% compartir el archivo al campus virtual

chi = 1 / sqrt(1 + ((pi/(log(Mp/100)))^2));

% ts = 4 / (wn*chi)
wn = 4 / (chi*ts)

w0 = wn * sqrt(1-chi^2)

% chi = cos alfa -> alfa = arc cos chi
% uso acosd que es el arco coseno en deg
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

fprintf("Calculo el Margen de Fase que debe ser igual a +-180°, para luego compensarlo");
MF = delta + beta + gamma

