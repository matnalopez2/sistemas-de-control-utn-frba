%{
Materia: Sistemas de Control
Carrera: Ingeniería Electrónica
Universidad Tecnológica Nacional – FRBA

Alumno: Matías Nahuel López

Guía de TP#1: Modelización de sistemas físicos y su representación gráfica mediante bloques
Ejercicio: 12 f
%}


clc;
s = tf('s');

G = ( ( 5*s + 12)/ ( s^2 + 5*s + 6) );

utils.print_pz(G);
utils.tvi_tvf_entrada_escalon(G);
utils.plot_step(G, 'Ejercicio 12 f', 10);