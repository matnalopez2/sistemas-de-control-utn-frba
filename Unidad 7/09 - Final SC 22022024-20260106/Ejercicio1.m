%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Ejercicio#1 Final SC 21/02/2024
%%%
%%% Dr. Ing. Franco Pessana
%%% Facultad Regional Buenos Aires
%%% Universidad Tecnológica Nacional
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc

MA = [0 1 0 0;0 0 1 0;0 0 0 1;0 60 -4 -11];
MB = [0 0 0 1]';
MC = [1.5 1 0 0];
MD = 0;

b0 = 1.5;
a1 = 60;
a2 = 4;
a3 = 11;

disp('Polos de la Planta sin Controlar:')
P_LA = eig(MA)
disp('Polos a Lazo Cerrado queridos:')
P_LC = [-2+1j*2 -2-1j*2 -1.5 -10]'
disp('Vector de realimentación de Estados')
K = acker(MA,MB,P_LC)
disp('Ganancia de la señal de referencia:')
g0 = 1/(MC*inv(MB*K-MA)*MB)
A_New = MA - MB*K;
B_New = g0*MB;
ME = ss(A_New,B_New,MC,MD);
H=figure(1);
set(H,'NumberTitle','off','Menubar','none','name','Ejercicio#1 Final SC 24/05/2023',...
    'position',[20 30 1000 700]);
step(ME)
grid