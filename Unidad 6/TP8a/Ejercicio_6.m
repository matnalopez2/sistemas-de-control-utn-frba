% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Ejercicio 6 - Guía de TP 8a
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Inicialización
clear all; clc; close all;
s = tf('s')

% Datos del problema

Mp_enunciado = 40;     % porciento
ts = 5;      % seg

G = tf(10, [1 0 2])
[numG, denG] = tfdata(G, 'v')

% rlocus(G)
% step(G)

% Resolución

Mp  = 4.32;     % Defino Mp que ya se que cumple y defino PLC con alfa=45°
chi = 0.707;     % chi para el Mp definido arbitrariamente
PLC = -4 + 1j*4;

poles = pole(G)

alfa = angle(PLC - poles(1))*180/pi
beta = angle(PLC - poles(2))*180/pi

MF = alfa + beta

gamma = MF - 180
a = imag(PLC) / tand(gamma)

z = - real(PLC) - a;  

Gc = (s + z)
[numGc, denGc] = tfdata(Gc, 'v')

L = Gc*G
figure;rlocus(L)
figure;pzmap(L)
[k , polos] = rlocfind(L, PLC)

M = feedback(Gc*G, 1)
figure;pzmap(M)
figure;step(M)

