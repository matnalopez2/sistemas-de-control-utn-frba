%{
Materia: Sistemas de Control
Carrera: Ingeniería Electrónica
Universidad Tecnológica Nacional – FRBA

Alumno: Matías Nahuel López

Guía de TP#1: Modelización de sistemas físicos y su representación gráfica mediante bloques
Ejercicio: 12 a
%}

clc;

s = tf('s');
G = (9 - 3*s) / ((s+1)*(s+7));

utils.print_pz(G);

% TVI/TVF para entrada escalón
utils.tvi_tvf_entrada_escalon(G);

% Grafico
utils.plot_step(G, 'Ejercicio 12a - Respuesta al escalon', 8);