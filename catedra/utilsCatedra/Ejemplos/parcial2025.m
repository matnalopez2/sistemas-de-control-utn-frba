clc; clear; close all;

%% Datos
q0 = 0.01;
m = 50;
b = 100;
r = 15e3;
k = 3e3;
a = 0.1;
p = 1e3;
g = 9.81;

c = 10/(p*g);

%% Planta
A = [-1/(r*c) -1/c 0;
    a^2/m -b/m -a^2/m;
    0 k/a^2 0];
B = [1/c 0 0]';
C = [1/(p*g) 0 0;
    0 0 a/k];
D = [0;0];

G = ss(A,B,C,D);
G1 = G(1);
G2 = G(2);

G1 = tf(G1)
G2 = tf(G2)
% Sigue en simulink

%% Control Moderno
epsilon = overshoot2damping(5)
beta = rad2deg(acos(epsilon))

plc = [-2+1i -2-1i -10];
Rinf = [q0];
Yinf = [1.53; 0.5];

% Forma 1:
%[K, K0, ~, ~] = control(A,B,C,D, plc, Rinf=Rinf, Yinf=Yinf)

% Forma 2:
[K, ~] = stateFeedback(A, B, C, D, plc);
K0 = prefilterFeedback(A,B,C,D,K,Rinf=Rinf, Yinf=Yinf);

% Sigue en simulink real_estados

%% Control Moderno con estimación
pest = [-10 -11 -12];

% Forma 1:
[K, ~, Ke, K00] = control(A,B,C,D, plc, Pest=pest, Rinf=Rinf, Yinf=Yinf);

% Forma 2:
%[K, ~] = stateFeedback(A, B, C, D, plc)
%Ke = stateEstimator(A,C,pest);
%K00 = prefilterEstimator(A,B,C,D,K,Ke, Rinf=Rinf, Yinf=Yinf);


[Aest, Best, Cest, Dest] = caso4(A, B, C, Ke);      
% Sigue en simulink caso4

%% Control Moderno con estimador Digital
Ts = 0.05;      % Ts = 0.1* 1/Polo_dominante
[Ad, Bd] = c2d(A,B,Ts);
Cd = C;
Dd = D;

pestd = exp(pest*Ts);
plcd = exp(plc*Ts);

[Kd, K0d, Ked, K00d] = control(Ad,Bd,Cd,Dd, plcd, Pest=pestd, Ts=Ts,  Rinf=Rinf, Yinf=Yinf);
[Aestd, Bestd, Cestd, Destd] = caso4(Ad, Bd, Cd, Ked);      
% Sigue en simulink caso4_adc

%% Control clásico
epsilon = overshoot2damping(5)
beta = rad2deg(acos(epsilon))
[polos, ceros] = pzmap(G2)

x = -.8 + 8i;           %% Prueba con polos que no van a cumplir el sobrepico
[~, pos_cero] = anguloCero(polos, ceros, x);
Gc = tf(poly([-0.0652 pos_cero]), [1 0]);   %% PID
[K, ~] = rlocusGain(Gc*G2, x);

M = feedback(Gc*G2*K, 1);
figure; step(M);

%%% El PID directamente es imposible. Se eligieron polos en .8+j.8 que no
%%% complen con la consigna solo para mostrar un ejemplo.
