%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Ejercicio 1. Final SC 21-12-2023
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

A = [0 G2*(G6a+G6b)/(C5*G1);-G4/C3 0]
B = [G6a/C5 0]'
C = [0 -(1+G1/G2)]
D = 0

[NGE,DGE] = ss2tf(A,B,C,D);
disp('Ganancia del Oscilador Activo con Modelo de Estados:')
GE = tf(NGE,DGE)

MCon = ctrb(A,B);
disp('Rango Matriz de Controlabilidad:')
Rango_MCon = rank(MCon)

disp('Polos a lazo cerrado deseados:')
P_LC = [-100 -500]

disp('Vector de realimentación de Estados:')
K = acker(A,B,P_LC)

disp('Ganancia de la señal de referencia:')
G0 = 1/(C*inv(B*K-A)*B)

AN = A - B*K;
BN = G0*B;

disp('Transferencia del filtro realimentado:')
[NGER,DGER] = ss2tf(AN,BN,C,D);
GEReal = tf(NGER,DGER)

MEstReal = ss(AN,BN,C,D);

H_1=figure(1);
set(H_1,'position',[20 50 1200 700],'Menubar','none',...
     'NumberTitle','off','name','Ejercicio #2. Final SC 21/12/2023. Bode de G(s) Sin y Con Estados Realimentados');
bode(G,MEstReal)
grid
legend('G(s)','G_REAL(s)')
H_2=figure(2);
set(H_2,'position',[80 50 1200 700],'Menubar','none',...
     'NumberTitle','off','name','Ejercicio #2. Final SC 21/12/2023. Respuesta al Escalon');
step(G,GEReal,.5);
legend('G(s)','G_REAL(s)')
grid
stepinfo(GEReal)