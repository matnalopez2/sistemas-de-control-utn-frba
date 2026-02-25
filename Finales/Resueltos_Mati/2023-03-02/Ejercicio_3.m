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

G = 1 / (20*s*s + 80);
[numG, denG] = tfdata(G, 'v');

%% Resolución

PLC = -4 + 4i;
polos = pole(G);

p1 = polos(1);
p2 = polos(2);
p3 = 0;

alfa = angle(PLC - p1)*180/pi
beta = angle(PLC - p2)*180/pi
gama = angle(PLC - p3)*180/pi

CF = (alfa + beta + gama)

tita = (CF - 180)/2

a = imag(PLC) / tand(tita)

z = - (real(PLC) - a)

Gc = (s+z)^2/s
num_Gc = tfdata(Gc, 'v');

% figure;rlocus(Gc*G)
[kD, polos_f] = rlocfind(Gc*G, PLC)

kP = num_Gc(2) * kD
kI = num_Gc(3) * kD

% M = feedback(kD*Gc*G, 1);
% pzmap(M)


PLC_VE = [-4+4i -4-4i]

A = [0 1; -k/m 0]
B = [0; 1/m]
C = [1 0]
D = [0]


K = acker(A, B, PLC_VE)
An = A - B*K;
eig(An)

g0 = utilsMati.realim_VE.factorEscala(A,B,C,K)

PLC_est = [-4+4i -4-4i]

Ke = acker(A', C', PLC_est)'
A_est = A - Ke*C;
B_est = [B Ke]  
C_est = eye(2);
D_est = [0 0;0 0]';
