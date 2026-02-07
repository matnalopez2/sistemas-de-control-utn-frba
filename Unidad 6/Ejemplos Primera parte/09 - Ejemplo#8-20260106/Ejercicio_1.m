%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Ejercicio #1 Control PD + Prefiltro 
%%%
%%% Dr. Ing. Franco Pessana
%%%
%%% Final Sistemas de Control 24-02-2021
%%%
%%% FRBA
%%% Universidad Tecnológica Nacional
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc


disp('Ganancia de la Planta sin controlar:')
G = tf(2,[1 0 0])
disp('Polos a lazo cerrado deseados:')
PLC = -2 +1j*2*sqrt(3)
Gamma = angle(PLC - 0)*180/pi
Beta = 2*Gamma - 180
a = imag(PLC)/tan(Beta*pi/180)
disp('Cero del Controlador PD:')
Z = real(PLC) - a
Gc = tf([1 -Z],1);
H = 1;
GH = Gc*G*H;
F1=figure(1);
set(F1,'NumberTitle','off','Menubar','none',...
    'name','Ejercicio #1. Final SC 24/02/2022. Rlocus de Gc(s)*G(s)*H(s)',...
    'position',[20 30 1200 800]);
rlocus(GH)
sgrid
disp('De rlocus (o analiticamente), constante derivativa:')
KD = 2
disp('Constante de Proporcionalidad:')
KP = abs(Z)*KD
disp('Controladpr PD')
Gc = KD*Gc
F2=figure(2);
set(F2,'NumberTitle','off','Menubar','none',...
    'name','Ejercicio #1. Final SC 24/02/2022. Respuesta al Escalón sin Prefiltro',...
    'position',[100 30 1200 800]);
disp('Ganancia a lazo cerrado sin prefiltro:')
M1 = feedback(Gc*G,H)
step(M1)
grid
Kf = 4;
disp('Ganancia del Prefiltro')
Gf = tf(Kf,[1 -Z])
[NGf,DGf] = tfdata(Gf,'v');

F3=figure(3);
set(F3,'NumberTitle','off','Menubar','none',...
    'name','Ejercicio #1. Final SC 24/02/2022. Respuesta al Escalón con Prefiltro',...
    'position',[180 30 1200 800]);
disp('Ganancia a lazo cerrado con prefiltro:')
M = Gf*M1
step(M)
grid