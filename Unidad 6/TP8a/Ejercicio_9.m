% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Ejercicio 9 - Guía de TP 8a
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Inicialización

clear all; clc; close all;
s = tf('s');

T_inicio    = 0;
delta_t     = 0.01;
T_final     = 100;
t           = (T_inicio:delta_t:T_final)';


%% Datos del problema

k=1;

G1 = 10 / (s*(s+1));
G2 = (s+1.4)/(s+5);
H1 = k*s / (s+10);

chi = 0.5;

%% Resolución

P = [1 16 75 164 140];
Q = [10 50 0];

PQ = tf(Q,P)

% rlocus(PQ); grid on;

% Del rlocus k=9.06
kf = 9.06

H2 = kf*s / (s+10);
M1 = feedback(G1,H2);
M = feedback(G2*M1, 1);
% MP = feedback(kf*PQ, 1);
% figure; step(M); grid on;
% figure(1); pzmap(M); grid on;
% figure(2); pzmap(MP); grid on;
% pole(M)


Kv = dcgain(s*M1*G2)
ess_rampa = 1/Kv

% 1) POSICION: referencia escalón
r_step = ones(size(t));
y_step = lsim(M, r_step, t);
e_step = r_step - y_step;

figure; plot(t, y_step, t, e_step); grid on;
legend('y(t) posición','e(t) pos');
title('Posición y error de posición (entrada escalón)');

% 2) VELOCIDAD: referencia rampa de posición r(t)=t
r_ramp = t;
y_ramp = lsim(M, r_ramp, t);
e_ramp = r_ramp - y_ramp;


figure; plot(t, y_ramp, t, r_ramp); grid on;
legend('y(t)','e(t)=r-y');
title('Entrada rampa: salida y error de posición');

