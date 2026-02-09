clc; clear; close all;

%% Datos
m1 = 180;
k1 = 1000;
k2 = 1500;
b1 = 625;

%% Matrices de estados
A = [0 1 0; 
    -(k1+k2)/m1 0 k1/m1;
    k1/b1 0 -k1/b1];
B = [0 0; k2/m1 0; 0 1];
C = [1 0 0];
D = [0 0];

M_ol = ss(A,B,C,D);

%step(Mtot);
%Posee 2 entradas, no tiene sentido

%% Otra forma: (Funcion Transferencia)
disp("Funcion transferencia")
M_ol = tf([(k1+k2)/m1 k1*k2/(m1*b1)], [1 k1/b1 (k1+k2)/m1 k1*k2/(m1*b1)]);
figure();
step(M_ol);
title("Funcion transferencia");
hold on;
[polos, ceros] = pzmap(M_ol)
eig(M_ol);

%% Otra forma: (matriz canónica)
disp("Matriz canonica")
A = [0 1 0;
    0 0 1;
    -k1*k2/(m1*b1) -(k1+k2)/m1 -k1/b1];
B = [0 0 1]';
C = [k1*k2/(m1*b1) (k1+k2)/m1 0];
D = [0];

M_ol = ss(A,B,C,D);
figure();
step(M_ol);
title("Matriz canonica");
hold on;

eig(M_ol);

%% Control clásico
% Nota: me quedo con el tf de M_ol
fprintf("Control clásico:\n\n")
Mp = 10;
ts = 2;
epsilon = overshoot2damping(Mp);

% Elijo PID:
% Un cero en -1, polo en el origen. Me falta el otro cero
polos = [polos; 0]
ceros = [ceros; -1]
x = -3.5+3.5i;
[~, pos_cero] = anguloCero(polos, ceros, x);

kc = tf(poly([-1 pos_cero]), [1 0])
F = kc * M_ol;
[K, ~] = rlocusGain(F, x);   % Se obtiene K=0,475

[KP,KD,KI] = pidValues(K, [0], [-1 pos_cero]);

M_cl = feedback(K*kc*M_ol, 1);
figure();
step(M_cl);
title("Sistema controlado");

figure();
pzmap(M_cl);
title("Polos y Ceros controlado");

% No responde como queremos porque hay un cero en -1 y aun queda el polo en
% el origen.


%% Realimentación y control moderno

% Usamos las matrices previamente definidas A,B,C,D
% Definimos los polos a lazo cerrado. Son 3 estados.
Plc = [-4 -3 -0.96];
Pest = [-20 -20.5 -21];
Rinf = 1;
Yinf = 1;
[K, Go, Ke, Goo] = control(A,B,C,D, Plc, Pest=Pest, Rinf=Rinf, Yinf=Yinf);

[Aest, Best, Cest, Dest] = caso2(A, B, C, Ke);
% A simulink

%% Realimentación y control moderno digital
Ts = 0.03;
[Ad, Bd] = c2d(A,B,Ts);
Cd = C;
Dd = D;

Plc_d = exp(Plc*Ts);
Pest_d = exp(Pest*Ts);

[Kd, God, Ked, Good] = control(Ad,Bd,Cd,Dd, Plc_d, Pest=Pest_d);

[Aestd, Bestd, Cestd, Destd] = caso4(Ad, Bd, Cd, Ked);  % Para caso 4_adc.

% NOTA: El caso 4 no funcionaba de forma analógica, por lo tanto tampoco
% funcionará de forma digital.Se debe añadir ADC y DAC al caso 2 y probar
% con ese.

% [Aest, Best, Cest, Dest] = caso4(A, B, C, Ke);
% El digital se comportará igual a este.


