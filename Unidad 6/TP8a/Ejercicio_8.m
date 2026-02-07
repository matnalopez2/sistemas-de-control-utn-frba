% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Ejercicio 8 - Guía de TP 8a
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Inicialización

clear all; clc; close all;
s = tf('s');

%% Datos del problema

% syms K Kh

G = 1 / s;
H = 1;

chi = 0.5;
ts = 2;     % Segundos
Kv = 50;    % 1/seg
% 0 < Kh < 1


%% Resolución

wn = Kv;
w0 = wn * sqrt(1-chi^2);

PLC = - (chi*wn) + w0*i;

K = 5000
Kh = (2*50 - 1)/K

M = tf([K/2], [1 (1+Kh*K)/2 K/2]);

figure; step(M)
figure; pzmap(M)

Mp = 16.3;

chi_final = utils.disenio_compensadores.factor_amort_desde_sobrepico(Mp)


