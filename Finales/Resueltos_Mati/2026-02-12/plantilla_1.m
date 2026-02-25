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


m = 48;
bm = 0;
b1 = 250/3;
k1 = 1000;
k2 = 200;

numG = [b1*(k1+k2) k1*k2];
denG = [m*b1 (m*k1 + b1*bm) (b1*k1+b1*k2+bm*k1) k1*k2];

%% Resolución

G = tf(numG, denG)

pole(G)

PLC = -4 + 4i;

p1 = -1 + 2i;
p2 = 0;
p3 = -1 - 2i;
p4 = -10;
z1 = -2;

alfa  = angle((PLC - p1))*180/pi
beta  = angle((PLC - p2))*180/pi
gamma = angle((PLC - p3))*180/pi
delta = angle((PLC - p4))*180/pi
epsilon = angle(PLC - z1)*180/pi

MF = epsilon - alfa - beta - gamma - delta 

tita = MF / 2 

% a = real(PLC) / tand(tita)
% z = - real(PLC) - a

z = 5.7
% 
% 
Gc = (s+z)^2 / s;
L = Gc * G;

figure; rlocus(L)
[kd, polos] = rlocfind(L, PLC)







M = feedback(kd*Gc*G, 1);
figure; step(M)
stepinfo(M)
figure; pzmap(M)

% pole(M)

