clc; clear; close all;

%% Datos
m = 0.65;
b = 1.523;
k1 = 1;
k2 = 19.8;

kt = k1+k2;

%% Planta

num = [b k2];
den = [m*b k2*m b*kt k1*k2];
G = tf(num,den);
figure; step(G);
[polos, ceros] = pzmap(G)

%% Control Clásico
H = 1;

epsilon = overshoot2damping(15)
beta = rad2deg(acos(epsilon))

Gc = tf(poly([-1 -2]), [1 0]);   %Elijo PID con ceros en -1, -2
x = -7 + 2i;

[K, ~] = rlocusGain(Gc*G*H, x);

M = feedback(K*Gc*G, H);
figure; step(M);
figure; pzmap(M);

%% Control Moderno

plc = [-10 -6+2i -6-2i];    % Se elije polo dominante -5+j2
pest = [-30 -30 -30];
[A, B, C, D] = tf2ss(num, den);

[K, K0, Ke, K00] = control(A,B,C,D, plc, Pest=pest);
[Aest, Best, Cest, Dest] = caso4(A,B,C,Ke);
% Ver simulink

%% Control Moderno Digital
Ts = 0.02;

plcd = exp(plc*Ts);
pestd = exp(pest*Ts);

[Ad, Bd] = c2d(A,B,Ts);
Cd = C;
Dd = D;

[Kd, K0d, Ked, K00d] = control(Ad,Bd,Cd,Dd, plcd, Pest=pestd, Ts=Ts);
[Aestd, Bestd, Cestd, Destd] = caso4(Ad,Bd,Cd,Ked);
