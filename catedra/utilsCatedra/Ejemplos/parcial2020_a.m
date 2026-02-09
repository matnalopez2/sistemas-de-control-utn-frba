clc; clear; close all;

%% Ejercicio 1-a
tau = 50;

G = tf([1], [tau 1]);
epsilon = overshoot2damping(5)

[polos, ceros] = pzmap(G)

% Control PI eliminando el polo cercano al eje.
Gc = tf(poly(-0.02), [1 0]);
x = -5;
figure; rlocus(Gc*G);       %% Tanto rlocus como rlocusGain no grafican hasta K=250. Se resolvió a mano
axis([-6 1 -.2 .2]);
k = 250;    % Para PLC=-5

M_lc = feedback(k*Gc*G,1);
%figure; pzmap(M_lc)
figure; step(M_lc)

%% Ejercicio 1-b
TS = 0.1;
G_d = c2d(G,TS)

PLC = exp(-5*TS)

% Control PI digital
% Igual que antes, se utilizará el cero para elimianr el polo
cero = exp(-0.02*TS);
Gc_d = tf([1 -cero], [1 -1], TS);

[K, ~] = rlocusGain(G_d*Gc_d, PLC);

M_lc_d = feedback(K*Gc_d*G_d, 1);
figure;
step(M_lc_d)
hold ON;
step(M_lc)