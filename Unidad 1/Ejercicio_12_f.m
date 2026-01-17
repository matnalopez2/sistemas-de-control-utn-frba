%{
Materia: Sistemas de Control
Carrera: Ingeniería Electrónica
Universidad Tecnológica Nacional – FRBA

Alumno: Matías Nahuel López

Guía de TP#1: Modelización de sistemas físicos y su representación gráfica mediante bloques
Ejercicio: 12 c
%}


clc;
s = tf('s');

G = ( ( (4*s^2) + 7*s + 4)/ ((s+2)*(s^2+s+1)) );

utils.print_pz(G);
utils.tvi_tvf_entrada_escalon(G);
utils.plot_step(G, 'Ejercicio 12 c', 10);