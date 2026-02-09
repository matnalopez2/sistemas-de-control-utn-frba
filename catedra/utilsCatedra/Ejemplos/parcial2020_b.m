clc; clear; close all;

%% Datos:
a = 20;
kp = 10;

ra = 1;

jm = 0.9;
bm = 6.2;
kb = 1;

ch = 1;
rh = 10;
kv = 0.1;

%% Planta
p1 = bm/jm;
p2 = 1/(ch*rh);

num = (a*kb*kv)/(ra*jm*ch);
den = [1 p1+p2+kb^2/(ra*jm) p1*p2+p2*kb^2/(ra*jm) 0];
G = tf(num, den);
H = kp;

M_la = G*H
[polos, ceros] = pzmap(M_la)

%% Control clásico
epsilon = overshoot2damping(5)

% Aumentar tipo y eliminar polo en 0.1. Se usa PID
x = -1+1i;
[~, posCero] = anguloCero([0 0 -8], ceros, x);

Gc = tf(poly([-.1 posCero]), [1 0]);
[K, ~] =  rlocusGain(M_la*Gc, x);

M_lc = feedback(K*Gc*G, H);
M = feedback(G,H);

dcgain(M_lc)
figure; step(M_lc);
title('Respuesta al escalon. Sistema controlado');
figure; bode(K*Gc*M_la);
title('Bode Sistema controlado');

figure; bode(M_la);
title('Bode Sistema Original');
figure; step(M);
title('Respuesta al escalón. Sistema Original');
bandwidth(M)


