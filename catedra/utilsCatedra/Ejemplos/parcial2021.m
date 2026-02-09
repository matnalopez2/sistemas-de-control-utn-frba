clc; clear; close all;

%% Datos
a = 100;
kp = 1;

la = 1e-3;
ra = 10;

jm = 0.03;
bm = 0.003;

kb = 0.4;
j = 0.02;

r = 0.1;

ml = 5;
kl = 40;
bl = 0.1;

bt = bm + bl*r^2;
kt = kl*r^2;
jt = jm + j + ml*r^2;

%% Planta

num = a*kb*r/(la*jt);
den = [1 (ra/la+bt/jt) (ra/la)*(bt/jt)+(kt/jt)+kb^2/(la*jt) (ra/la)*(kt/jt)+(kb*r*kp*a)/(la*jt)];

M_lc = tf(num, den)

figure; step(M_lc);

num = a*kb*r/(la*jt);
den = [1 (ra/la+bt/jt) (ra/la)*(bt/jt)+(kt/jt)+kb^2/(la*jt) (ra/la)*(kt/jt)];
G = tf(num,den);
H = kp;
% M_lc = feedback(G,H) % --> Da lo mismo que antes

M_la = G*H;

[polos, ceros] = pzmap(M_la)

%% Control clásico
epsilon = overshoot2damping(20)
x = -3+3i;
[angCero, ~] = anguloCero([polos;0], ceros, x);
angCero = angCero/2;

cero = real(x) - imag(x)/tan(deg2rad(angCero))

Gc = tf(poly([cero cero]), [1 0])

[K, ~] = rlocusGain(M_la*Gc, x);
disp(K);
%K = 1.59;    % Del rlocus

M_lc = feedback(G*Gc*K, H)
figure; step(M_lc)

% No se logró por completo. Hay ceros muy cercanos al eje.

%% Control Moderno
% Usamos la ganancia a lazo abierto sin realimentar G
jeq = jm+j+r^2*ml;
beq = bm+r^2*bl;
keq = r^2*kl;

A = [-ra/la -kb/la 0;
    kt/jeq -beq/jeq -keq/(r*jeq);
    0 r 0];
B = [a/la 0 0]';
C = [0 0 1];
D = [0];

plc = [-4+4i -4-4i -10];

%[num, den] = tfdata(G, 'v');
%[A,B,C,D] = tf2ss(num, den);
[K, K0, ~, ~] = control(A,B,C,D, plc);

% Sigue en simulink

%% Control moderno + estimacion
pest = [-20 -20 -20];

% forma 1:
%[K, K0, Ke, K00] = control(A,B,C,D, plc, Pest=pest);

% forma 2:
[K, ~] = stateFeedback(A,B,C,D,plc);
K0 = prefilterFeedback(A,B,C,D,K);
Ke = stateEstimator(A,C,pest);
 
[Aest, Best, Cest, Dest] = caso2(A, B, C, Ke);  % El caso 4 no anda en este ejercicio
% Sigue en simulink


%% Control Moderno Digital
TS = 0.025; 

pestd = exp(pest*TS);
plcd = exp(plc*TS);

[Ad,Bd] = c2d(A,B,TS);
Cd = C;
Dd = D;

[Kd, K0d, Ked, K00d] = control(Ad,Bd,Cd,Dd, plcd, Pest=pestd, Ts=TS);
[Aestd, Bestd, Cestd, Destd] = caso2(Ad, Bd, Cd, Ked);
