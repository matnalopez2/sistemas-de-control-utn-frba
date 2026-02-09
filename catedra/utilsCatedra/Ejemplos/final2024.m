clc; clear; close all;

%% Datos
ra = 2;
la = 0;
kb = 0.2;
j = 0.01;
b = 0.03;
eta = 1/5;

%% Planta
num = kb/(j*eta*ra);
den = [1 (b+kb^2)/j 0];
G = tf(num, den);
[polos, ceros] = pzmap(G)

%% Control clásico
beta = rad2deg(acos(overshoot2damping(10)))

x = -5+2i;
[~, posCero] = anguloCero([0 0], [], x);
Gc = tf(poly([-7 posCero]), [1 0]);     % PID

[K, ~] = rlocusGain(Gc*G, x);

M_con_clasico = feedback(K*Gc*G, 1 );
figure; step(M_con_clasico);

% No cumple. El cero molesta.

%% Ejercicio 3
k1 = 1.2;
k2 = 1.3;

G = tf([k1], [1 -1 0]);
H = tf([k2 1], [1]);

figure; nyquist(G*H);


