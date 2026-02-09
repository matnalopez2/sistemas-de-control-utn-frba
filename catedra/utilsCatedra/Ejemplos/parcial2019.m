clc; clear; close all;

%% Ejercicio 1
A = [0 1 0 0;
    0 0 1 0;
    0 0 0 1;
    0 60 -4 -11];
B = [0 0 0 1]';
C = [1.5 1 0 0];
D = 0;

G = ss(A,B,C,D);
%pzmap(G);

beta = rad2deg(acos(overshoot2damping(5))) 
% Elegí polos en -2+j1 dominantes

plc = [-2+1i -2-1i -1.5 -20];

[K, K0, ~, ~] = control(A,B,C,D,plc);

An = A-B*K;

M_lc = ss(An, B, C, D);
M_lc = K0 * M_lc;
figure; step(M_lc);
figure; pzmap(M_lc);

%% Ejercicio 2
T1 = 0.4;
T2 = 0.2;
epsilon = overshoot2damping(5)

G = tf(poly(1/T1), poly([-1/T2 -1/T1 0]));
G = G/T2;      
figure; rlocus(-G);     %El menos es para graficar K negativos.

K = -0.348;     %% Valor donde se hacen dobles
M_lc = feedback(K*G, 1);
figure; step(M_lc);
figure; bode(K*G);

%% Ejercicio 3
epsilon = overshoot2damping(4.32)
G = tf(1, poly([-1 -6]))

K = 4.5; 
Gc = K*tf(poly([-1 -6]), [1 0]);

M = feedback(Gc*G, 1);
figure;step(M);title('Ejercicio 3 controlado PID');

figure;bode(M);title('Ejercicio 3 controlado PID');

figure;bode(Gc*G);title('Ejercicio 3 controlado PID. MF y MG');



