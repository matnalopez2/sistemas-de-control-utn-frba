clc; clear; close all;

m = 80;     % kg
k = 340;    % N/m
b = 80;     % N.s/m
KP = 1;     % v/m
kd = 1;

NG = b/m * [1 k/b];
ZG = roots(NG);
DG = [1 b/m k/m];
PG = roots(DG);

fprintf("Me queda una G(s):");
G = tf(NG, DG);
display(G)

disp(" ")
disp("Defino los Polos dominantes a Lazo Cerrado para asegurar ts(2%) < 1seg definiendo:");
disp("\tMp=4,32% por Epsilon=0,707");
PLC = -4 + 1j*4


Alfa    = angle(PLC - ZG)       * 180/pi;
Gamma   = angle(PLC - PG(1))    * 180/pi;
Delta   = angle(PLC - PG(2))    * 180/pi;
Epsilon = angle(PLC - 0)        * 180/pi;

Beta = ((Epsilon + Gamma + Delta - 180 - Alfa)/2);

fprintf("Según el criterio de fase, calculo los ángulos:\n");
fprintf("\t1. Alfa: %.2f°\n", Alfa);
fprintf("\t2. Gamma: %.2f°\n", Gamma);
fprintf("\t3. Delta: %.2f°\n", Delta);
fprintf("\t4. Epsilon: %.2f°\n", Epsilon);
fprintf("Entonces, me queda Beta: %.2f\n", Beta);

a = imag(PLC)/tan(Beta*pi/180);
Z = real (PLC) - a;
Gc = tf(conv([1 -Z], [1 -Z]), [1 0]);
[NGc, DGc] = tfdata(Gc, 'v');
NGc

H   = KP;

H1 = figure(1);
set (H1, 'name', 'Ejercicio 2 - Final 06-dic-2021. BNode Gc(s)G(s)H(s)')
rlocus(Gc*G*H)
grid;

disp('De RLOCUS saco los valores de las constantes.')
disp('Constante derivativa: ')
kd = 2.16
disp('Constante proporcional: ')
kp = kd * NGc(2)
disp('Constante integral: ')
ki = kd * NGc(3)
disp('Ganancia del Controlador PID')
Gc = kd * Gc

H2 = figure(2);
set(H2, 'name', 'Ejercicio #2 - Final 06-dic-2021. Respuesta al escalón')
disp('Ganancia a lazo cerrado:')
M=feedback(Gc*G, H)
step(M,2)

[NM, DM] = tfdata(M, 'v');
disp('Ceros a lazo cerrado: ')
PLC = roots(NM)
disp('Polos a lazo cerrado: ')
PLC = roots(DM)
grid
