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

m  = 0.65;
b  = 1.523;
k1 = 1;
k2 = 19.8;

num_G = s*b + k2;
den_G = s^3*m*b + s^2*m*k2 + s*b*(k1+k2) + k1*k2;


%% Resolución ejercicio 2


G = num_G / den_G
[numG, denG] = tfdata(G, 'v')
% pzmap(G)

ceros = zero(G)
polos = pole(G)

PLC = -5 + 5i;

p1 = polos(1);
p2 = polos(2);
p3 = polos(3);
p4 = 0;

z1 = ceros(1);

alfa    = angle(PLC - z1)*180/pi
beta    = angle(PLC - p1)*180/pi
gamma   = angle(PLC - p2)*180/pi
delta   = angle(PLC - p3)*180/pi
epsilon = angle(PLC - p4)*180/pi

CF = alfa - beta - gamma - delta - epsilon

tita = (- CF - 180)/2
a = imag(PLC) / tand(tita);

z_prima = real(PLC) - a;

z = - z_prima
Gc = (s+z)*(s+z)/s;

% rlocus(Gc*G)
[kD, politos] = rlocfind(Gc*G, PLC)
% M = feedback(Gc*G, 1);
% figure; step(M)

kP = 6.6 * kD
kI = 3.3*3.3*kD

[numGc,denGc] = tfdata(Gc, 'v')


%% Resolución ejercicio 3

% A = [0 -1/m -1/m; k1 0 0; k2 0 -k2/b];
% B = [1/m; 0; 0];
% C = [1 0 0];
% D = [0];


[A, B, C, D] = utilsMati.generales.tf2ss_mati(numG, denG)

PLC_VE = [-5+5i -5-5i -20];

K = acker(A, B, PLC_VE);

An = A - B*K;
polos_VE = eig(An);

g0 = utilsMati.realim_VE.factorEscala(A,B,C,K);




Ke = acker(A',C',PLC_VE)' %Calculo la matriz K
