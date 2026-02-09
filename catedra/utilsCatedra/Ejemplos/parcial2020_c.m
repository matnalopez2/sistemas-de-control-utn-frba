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
% Estados: X1=h X2=theta X3=vel. angular
A = [-1/(ch*rh) kv/ch 0;
    0 0 1;
    0 0 -(bm+kb/ra)/jm];
B = [0 0 kb/(ra*jm)]';
C = [1 0 0];
D = 0;

M_la = ss(A,B,C,D);
%figure; pzmap(M_la)   %Chequeo

epsilon = overshoot2damping(5);
% elijo polos en -2+j2
plc = [-2+2i -2-2i -15];
r_inf = 1;
y_inf = 1.5;

% Forma 1:
%[K, K0, ~, ~] = control(A,B,C,D, plc, Rinf=r_inf, Yinf=y_inf);
% Forma 2:
[K, An] = stateFeedback(A,B,C,D, plc);
K0 = prefilterFeedback(A,B,C,D,K, Rinf=r_inf, Yinf=y_inf);

% sigue en simulink

% Sin simulink:
%An = A-B*K;
M_lc = ss(An, B, C, D);
M_lc = K0*M_lc;
figure;step(M_lc);
title('Respuesta al escalon. Sistema controlado')
