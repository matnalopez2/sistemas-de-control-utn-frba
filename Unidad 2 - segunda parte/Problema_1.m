clc;
clear;


%% Datos del problema

ea = 300;       % v
Ra = 1;         % ohm
La = 0.05;      % Hy
kt = 1.10;      % Nm/A
Jm = 0.4;       % J.seg²
bm = 0.005;     % J.seg
JL = 0.8;       % J.seg²
bL = 0.1;       % J.seg
Lc = 9;         % Hy
Rc = 60;        % ohm

%% Resolución
b = bm + bL;
J = Jm + JL;
kb = kt;

s = tf('s');
Gplanta = (kt / ((Ra + s*La) * (b + s*J) + kb*kt));
G = ea * Gplanta;

[w_0, w_Inf] = utils.tvi_tvf_entrada_escalon(G);
%dcgain(G)
%utils.plot_step(G, 'Respuesta al escalón', 7);

Ia = w_Inf * (b / kt);

pmL = bL * (w_Inf^2)
pmM = bm * (w_Inf^2)
peA = ea * Ia
peC = 0; % (ea^2) / Rc pero no tengo datos, así que desprecio

pm = pmL + pmM ;
pe = peA + peC;

rendimiento1 = pmL / (pmM + pmL)
rendimiento2 = pmL / peA
rendimiento3 = pm / pe
