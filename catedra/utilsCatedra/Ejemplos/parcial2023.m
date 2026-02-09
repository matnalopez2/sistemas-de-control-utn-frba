clc; clear; close all;

%% Datos
m1 = 100;
m2 = 517;

k1 = 958;
k2 = 4410;
b1 = 1500;

%% Matriz de estados
A = [-b1/m1 -1/m1 -1/m1 0;
    k1 0 0 0;
    k2 0 0 -k2;
    0 0 1/m2 0];
B = [1/m1 0 0 0]';
C = [0 1/k1 0 0];
D = [0];

% Polos y ceros
M_ol = ss(A,B,C,D);

[polos, ceros] = pzmap(M_ol)
%% Control clásico
H = 1;

% Elijo XXX:
posPolo = -1.5+1.5j;
[~, posCero] = anguloCero([polos; 0], [ceros; -1.0455], posPolo);

Gk = tf(poly([-1.0455 posCero]), [1 0]);

[G, ~] = rlocusGain(M_ol * Gk, posPolo);

M_cl = feedback(G*Gk*M_ol, H);
figure();
pzmap(M_cl);
title("Sistema con control clasico")

figure();
step(M_cl);
title("Sistema con control clasico")
% Hay ceros complejos conjugados + el polo en el origen que me matan todo.

%% Control moderno
plc = [-10 -12 -2 -10]; %% plc = [2.9206i -2.9206i -2 -10];
pest = [-6 -6 -6 -6];

[K, K0, Ke, K00] = control(A,B,C,D, plc, Pest=pest);
[Aest, Best, Cest, Dest] = caso2(A, B, C, Ke);

% Sigue en Simulink caso 2 --->

%% Control Moderno Digital
ts = 0.1;
plc_d = exp(plc*ts)
pest_d = exp(pest*ts)

[Ad, Bd] = c2d(A,B,ts);
Cd = C;
Dd = D;

[Kd, K0d, Ked, K00d] = control(Ad,Bd,Cd,Dd, plc_d, Pest=pest_d, Ts=ts);
[Aestd, Bestd, Cestd, Destd] = caso2(Ad, Bd, Cd, Ked);

