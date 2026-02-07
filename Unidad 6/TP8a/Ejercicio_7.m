% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Ejercicio 7 - Guía de TP 8a
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Inicialización

clear all; clc; close all;
s = tf('s');

%% Datos del problema

G = tf( (2*s + 1) / (s*(s+1)*(s+2)))
[denG, numG] = tfdata(G, 'v');
polesG = pole(G);
zerosG = zero(G);
% pzmap(G);

%% Resolución

% Defino PLC = -4 + j4 para cumplir con requisitos de diseño
% Mp < 30%
% ts < 3 seg

PLC = -4 + 4i;
chi = 0.707;
alfa = 45;

fprintf('Calculo el angulo para el polo en s=(%d)\n', polesG(1))
tita  = angle(PLC - polesG(1))*180/pi

fprintf('Calculo el angulo para el polo en s=(%d)\n', polesG(2))
beta  = angle(PLC - polesG(2))*180/pi

fprintf('Calculo el angulo para el polo en s=(%d)\n', polesG(3))
delta = angle(PLC - polesG(3))*180/pi

disp('Calculo el angulo para el cero')
gamma = angle(PLC - zerosG(1))*180/pi

MF = tita + beta + delta - gamma

epsilon = MF - 180

a = imag(PLC) / tand(epsilon)
z1 = - real(PLC) + a

Gc = (s + z1);

L = G*Gc;

% rlocus(Gc*G)
[k, polos] = rlocfind(L, PLC)

M = feedback(k*G*Gc, 1)
figure; step(M)