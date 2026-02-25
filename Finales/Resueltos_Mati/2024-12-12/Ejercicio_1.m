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

m = 20;
k = 80;

PLC = -3.92 + 3.92i;

%% Resolución


G = 1 / (m*s^2 + k)

[numG, denG] = tfdata(G, 'v')

polos = pole(G);

p1 = polos(1);
p2 = polos(2);
p3 = 0;

alfa = angle(PLC- p1)*180/pi
gamma = angle(PLC- p2)*180/pi
beta = angle(PLC- p3)*180/pi

sum_polos = alfa + beta + gamma

tita = (sum_polos - 180) / 2
a = imag(PLC) / tand(180-tita)

z = -3.92 + a
Gc = (s-z)^2 / s;

% rlocus(Gc*G)
[kD, poles] = rlocfind(Gc*G, PLC)

[numGc, denGc] = tfdata(Gc, 'v')

numGc(2)
kP = numGc(2) * kD
kI = numGc(3) * kD



% M = feedback(kD*Gc*G, 1);
% margin(M)

[A,B,C,D] = utilsMati.generales.tf2ss_mati(numG, denG);
PLC_VE = [-3.92+3.92i -3.92-3.92i]

K = acker(A,B,PLC_VE)

An = A - B*K;
eig(An)

g0 = utilsMati.realim_VE.factorEscala(A,B,C,K) * 1/20;
