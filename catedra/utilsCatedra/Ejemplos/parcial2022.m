clc; clear; close all;

%% Datos
% Nota: La consigna indicaba M=50 Ton --> [1Ton = 1e6 gr]
m = 50e3;
k1 = 40e3;
k2 = 10e3;
b1 = 10e3;
b2 = 1e3;

v0 = 200/9; % [200/9 m/s --> 80 KM/H] 

%% Planta
kt = k1+k2;

A = [-b1/m -1/m -1/m;
    k1 0 0;
    k2 0 -k2/b2];
B = [1/m 0 0]';
C = [1 0 0];
D = 0;

G = ss(A,B,C,D);
x0 = [v0 0 0];

num = [1/m k2/(m*b2) 0];
den = [1 (b1/m)+(k2/b2) (kt+k2*(b1/b2))/m k1*k2/(m*b2)];

G_mason = tf(num, den)

figure; initial(G, x0);

%% Lugar de Raices

% No pide control clásico, solo se realiza para conocer anomalías a
% eliminar.
disp("polos y ceros");
[polos, ceros] = pzmap(G)

% cero en -10 a eliminar.

%% Control moderno
% tiempo de 2seg --> parte real menor a -2
plc = [-10 -3 -20];
pest = [-15 -15 -15];

% Forma 1:
%[K, ~, Ke, ~] = control(A,B,C,D, plc, Pest=pest);

% Forma 2:
[K, ~] = stateFeedback(A,B,C,D,plc);
Ke = stateEstimator(A,C,pest);

[Aest, Best, Cest, Dest] = caso4(A, B, C, Ke);
% sigue en simulink caso 4

%% Ejercicio 3
Mp = 5
epsilon = overshoot2damping(Mp)

G = tf([1], [1 -4 13])


disp("polos y ceros");
[polos, ceros] = pzmap(G)

p1 = -4+4i

[angCero, ~] = anguloCero([polos; 0], ceros, p1);
angCero = angCero/2;
posCero = real(p1) - imag(p1)/tan(deg2rad(angCero))

% Controlador PID
Gc = tf(poly([posCero posCero]), [1 0])

[K, ~] = rlocusGain(G*Gc, p1);

[KP, KD, KI] = pidValues(K, [0], [posCero posCero])     % Solo visual

M_lc = feedback(K*Gc*G,1);
figure; step(M_lc);

% Obviamente no se puede realizar. El polo en el origen va a ser dominante
% siempre. Los ceros añadidos para estabilizar el sistema son mucho más
% dominantes de lo buscado.

%% Ejercicio 3 con Control Moderno

[num,den] = tfdata(G,'v');
[A,B,C,D] = tf2ss(num,den);

plc = [-5+4i -5-4i]
pest = [-20 -20]

[K, K0, Ke, K00] = control(A,B,C,D, plc, Pest=pest);

%% Ejercicio 4
TS = 0.03;
[Ad, Bd] = c2d(A,B,TS);
Cd = C;
Dd = D;
plc_d = exp(plc * TS);
pest_d = exp(pest * TS);

[Kd, K0d, Ked, K00d] = control(Ad,Bd,Cd,Dd, plc_d, Pest=pest_d, Ts=TS);
[Aestd, Bestd, Cestd, Destd] = caso4(Ad, Bd, Cd, Ked);  %% caso 4_adc


