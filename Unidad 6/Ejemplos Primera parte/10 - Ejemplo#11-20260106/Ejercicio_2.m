%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Ejercicio #2 Control de Posición de Amortiguador Moto mediante PID
%%%
%%% Dr. Ing. Franco Pessana
%%%
%%% Final Sistemas de Control 06-12-2021
%%%
%%% FRBA
%%% Universidad Tecnológica Nacional
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc

m = 80; % Kg
b = 80; % N.s/m
k = 340; % n/m
KP = 1; %v/m

NG = b/m*[1 k/b];
DG = [1 b/m k/m];
disp('Ganancia de la Planta a Controlar:')
G = tf(NG,DG)
disp('Cero y Polos de la Planta:')
ZG = roots(NG)
PG = roots(DG)
disp('Polo a lazo cerrado deseado:')
PLC = -4+1j*4

disp('Angulos para calculo del controlador:')
Alfa = angle(PLC-ZG)*180/pi
Gamma = angle(PLC-PG(1))*180/pi
Delta = angle(PLC-PG(2))*180/pi
Epsilon = angle(PLC-0)*180/pi
Beta = (Gamma + Delta + Epsilon - (180 + Alfa))/2
a = imag(PLC)/tan(Beta*pi/180);
disp('Cero del Controlador PI:')
Z = real(PLC) - a
Gc = tf(conv([1 -Z],[1 -Z]),[1 0]);
[NGc,DGc] = tfdata(Gc,'v');
H = KP;
GH = G*H;
H1=figure(1);
set(H1,'NumberTitle','off','Menubar','none',...
    'name','Ejercicio #2. Final SC 06/12/2021. Bode Gc(s)G(s)H(s)',...
    'position',[20 30 1200 800]);
rlocus(Gc*GH)
grid
%%%%%% De Rlocus %%%%%%
disp('Constante Derivativa:')
K_D = 2.18
disp('Constante proporcional:')
K_P = K_D * NGc(2)
disp('Constante Integral:')
K_I = K_D * NGc(3)
disp('Ganancia del Controlador PID:')
Gc = K_D*Gc
H2=figure(2);
set(H2,'NumberTitle','off','Menubar','none',...
    'name','Ejercicio #2 Final SC 06/12/2021. Respuesta al Escalón',...
    'position',[60 30 1200 800]);
disp('Ganancia a lazo cerrado:')
M=feedback(Gc*G,H)
step(M,1.5)
[NM,DM] = tfdata(M,'v');
disp('Ceros a lazo cerrado:')
PLC = roots(NM)
disp('Polos a lazo cerrado:')
PLC = roots(DM)
grid