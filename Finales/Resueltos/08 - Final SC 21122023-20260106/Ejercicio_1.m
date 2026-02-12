%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Ejercicio 1. Final SC 27/07/2023
%%% 
%%% Dr. Ing. Franco Pesssana
%%% Sistemas de Control
%%% FRBA
%%% Universidad Tecnológica Nacional
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc

R1 = 1e3;
R2 = R1;
R4 = 2e3;
R6a = R1;
R6b = R6a;
C3 = 10e-6;
C5 = C3;

G1 = 1/R1;
G2 = 1/R2;
G4 = 1/R4;
G6a = 1/R6a;
G6b = 1/R6b;

NG = (G1+G2)*G4*G6a/(C3*C5*G1);
DG = [1 0 G2*G4*(G6a+G6b)/(C3*C5*G1)];

disp('Ganancia del Oscilador Activo:')
G = tf(NG,DG)

H_1=figure(1);
set(H_1,'position',[20 50 1200 700],'Menubar','none',...
     'NumberTitle','off','name','Ejercicio #1. Final SC 21/12/2023. Bode de G(s)');
bode(G);
grid
H_2=figure(2);
set(H_2,'position',[80 50 1200 700],'Menubar','none',...
     'NumberTitle','off','name','Ejercicio #1. Final SC 21/12/2023. Respuesta al Escalon');
step(G,1);
grid