clear all
close all
clc

% Planta
G=tf(0.01*[1 0 8.53],[1 15 62 128 80])

% Controlador
Gc= zpk([-1 -10],[0],[60])

% Rlocus con un integrador
figure();rlocus(G*zpk([],[0],[1]))

% Rlocus completo
figure();rlocus(G*Gc)

% Planta controlada y realimentada
M=feedback(G*Gc,1)

% Respuesta al escalon
figure();step(M)

% Info de la respuesta
stepinfo(M)