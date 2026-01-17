%{
Ejercicio 12a
Respuesta al escalon del sistema:
G(s) = (9 - 3s)/((s+1)(s+7))
%}

clc;

s = tf('s');
G = (9 - 3*s) / ((s+1)*(s+7));

utils.print_pz(G);

% TVI/TVF para entrada escalón
utils.tvi_tvf_entrada_escalon(G);

% Grafico
utils.plot_step(G, 'Ejercicio 12a - Respuesta al escalon', 8);