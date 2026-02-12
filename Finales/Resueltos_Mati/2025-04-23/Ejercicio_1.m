% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Ejercicio 1
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

H = 1;

%% Resolución

G = 1/20 * tf([0 0 1], [1 0 k/m])
polos = pole(G)
ceros = zero(G)

% Propongo un PID
% Gc = kp + (ki/s) + kd*s;


% rlocus(G*H)

PLC = -3.92 + 3.92i

fprintf("Calculo el angulo para el primer polo")
delta = angle(PLC - polos(1))*180/pi

fprintf("Calculo el angulo para el segundo polo")
gamma = angle(PLC - polos(2))*180/pi

MF = delta + gamma


fprintf("Calculo el angulo para el polo del PID")
beta = angle(PLC - 0)*180/pi

MF2 = MF + beta
tita = (-540 + MF2) /2
% tita = 116/2

a = imag(PLC) / tand(tita)

z = abs(real(PLC)) + a

Gc = ((s+z)^2 / s)

rlocus(Gc*G)
[kD, poles] = rlocfind(Gc*G, PLC);

kI = 713.16;
kP = 716.58;

M = feedback(kD*Gc*G,1)
figure;step(M)
stepinfo(M)

figure; margin(M)
figure; bode(M)

% Realimentacion completa del vector de estados


[numg, denG] = tfdata(G, 'v')
[A,B,C,D] = utilsMati.generales.tf2ss_mati(numG, denG)

K = acker(A,B,PLC)


