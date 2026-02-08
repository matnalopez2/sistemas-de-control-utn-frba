% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Ejercicio 11 - Guía de TP 8a
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

PLC = -0.75 + 2i

% G = tf([2], [1 5 0 0])
G = 2/(s^2 * (1+0.2*s))
polos = pole(G)


%% Resolución


fprintf("Calculamos alfa para el primer polo ubicado en %d", polos(1))
alfa = angle(PLC - polos(1))*180/pi

fprintf("Calculamos alfa para el segundo polo ubicado en %d", polos(2))
beta = angle(PLC - polos(2))*180/pi

fprintf("Calculamos alfa para el tercer polo ubicado en %d", polos(3))
delta = angle(PLC - polos(3))*180/pi

MF = alfa + beta + delta

% MF = 246, entonces quiero ver que cero poner para llevarlo a 180

epsilon = MF - 180

wo = imag(PLC);
a = wo / tand(epsilon);
z = a - real(PLC);
Gc = (s + z);

G1 = Gc*G

% rlocus(G1)
[k, polos] = rlocfind(G1, PLC);

M = feedback(k*Gc*G,1);
zpk(M)


G3 = (s+80)/(s+10)

M1 = M * G3

zpk(M1)

% Respuesta al escalón
figure;step(M)
figure;step(M1)

% Respuesta a la rampa
r=t;

yM  = lsim(M, r, t, 'r');
yM1 = lsim(M1, r, t, 'b');

eM = r - yM;
eM1 = r - yM1;

figure; plot(t,yM,'b', t,r,'r'); grid on; title('Respuesta de M(t) a rampa unitaria'); xlabel('t'); ylabel('yM(t)')
% figure; plot(t,eM); grid on; title('Error de M(t) ante rampa'); xlabel('t'); ylabel('eM(t)')

figure; plot(t,yM1,'b', t,r,'r'); grid on; title('Respuesta de M1(t) a rampa unitaria'); xlabel('t'); ylabel('yM1(t)')
% figure; plot(t,eM1); grid on; title('Error de M1(t) ante rampa'); xlabel('t'); ylabel('eM1(t)')
