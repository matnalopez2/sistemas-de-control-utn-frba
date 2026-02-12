%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Ejercicio 1,2 y 3 Final SC 23/06/2021
%%%
%%% Realimentación y Estimación del Vector de Estados
%%%
%%% Sistemas de Control
%%% Facultad Regional Buenos Aires
%%% Universidad Tecnológica Nacional
%%%
%%% Dr. Ing. Franco Pessana
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc

M = 2; % Unidades mKs
m = 0.5;
l = 0.5;
g = 9.81;

%%%%%% Ejercicio #1

disp('Modelo de estados con A, B, C y D:')
A = [0 1 0 0;
     (M+m)*g/(M*l) 0 0 0;
     0 0 0 1;
     -m*g/M 0 0 0]
B = [0;-1/(M*l);0;1/M] 
C = [1 0 0 0;0 0 1 0]
D = [0;0]
disp('Polos de la Planta:')
PP = eig(A)

%%%%%%%% Ejercicio #2
[Ns,Ds] = ss2tf(A,B,C,D);
disp('Transferencia del ángulo:')
M1 = tf(Ns(1,:),Ds)
disp('Transferencia de la posición lineal:')
M2 = tf(Ns(2,:),Ds)


%%%%%%%%%%% Ejercicio #3
disp('Matriz de Controlabilidad:')
Cont = ctrb(A,B)
disp('Rango de la Matriz de Controlabilidad:')
R = rank(Cont)
disp('Polos a lazo cerrado queridos:')
PLC = [-1 + 1j*sqrt(3) -1 - 1j*sqrt(3) -5 -5]
disp('Vector de realimentación de estados:')
K = acker(A,B,PLC)
Cn = [0 0 1 0];
disp('Constante de la entrada de referencia:')
g0 = 1/(Cn*inv(B*K-A)*B)

An = A - B*K;
Bn = g0*B;

SiCont = ss(An,Bn,C,D);
H1 = figure(1);
set(H1,'position',[10 40 1200 700],'name','Sistema Controlado con Realimentación del Vector de Estados:','menubar','none')
step(SiCont,5)
grid

%%%%%% Estimación del vector de Estados
disp('Matriz de Observabilidad:')
OBser = obsv(A,Cn)
disp('Rango de la Matriz de Observabilidad:')
Rank_OBser = rank(OBser)
disp('Polos del estimador de estados')
PLC_Est = [-4 -4 -4 -4]
disp('Vector de Estados del Estimador:')
Ke = acker(A',Cn',PLC_Est)'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Ane = A - Ke*Cn;
Bne = [g0*B Ke];
Cne = eye(size(Ane,1));
Dne = zeros(size(Ane,1),2);
Obs_Est = ss(Ane,Bne,Cne,Dne);
t=(0:0.01:5)';
r_t=ones(size(t));
Planta_Cont = ss(An,Bn,Cn,0);
[y,t,X]=lsim(Planta_Cont,r_t,t); % Planta Controlada con Acker
Ue =[r_t y];
[Ye,te,Xe]=lsim(Obs_Est,Ue,t,[0 0 0 0]);
AEst = A - Ke*Cn - B*K; % Matriz de Estado del Estimador (Caso#3 y #4)
BEst = Ke; % Matriz de entrada del Estimador (Caso #3 y #4)
CEst = K; % Matriz de Salida del Estimador (Caso #3 y #4)
DEst = 0; % Matriz de Transmisión Directa del Estimador (Caso #3 y #4)
disp('Autovalores de la matriz A - Ke*C - B*K')
P_LC_T = eig (AEst)
disp('Ganancia del Controlador Observador:')
[NH,DH] = ss2tf(AEst,BEst,CEst,DEst);
H = tf(NH,DH) % Observador como Realimentador para Caso#4
disp('Ganancia a lazo cerrado del control con estimación antes de g00:')
M2r = feedback(M2,H)
disp('Ganancia de la señal de referencia:')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Primera Forma de calcular g00
%%% [NM2,DM2] = tfdata(M2r,'v');
%%% NM20 = NM2(length(NM2));
%%% DM20 = DM2(length(DM2));
%%% g00 = DM20/NM20
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Segunda Forma de calcular g00
M2r_0 = dcgain(M2r);
g00 = 1/M2r_0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Transferencia a lazo cerrado con realimentación por Observación de estados:')
M3 = g00*M2r
H2 = figure(2);
set(H2,'menubar','none','position',[30 20 1200 700],...
    'name','Respuesta al Escalón por Realimentación de Observación de Estados (g00)')
step(M3)
grid
disp('Ganancia a lazo cerrado por Controlador Serie de Observación de Estados:')
M4 = feedback(H*M2,1)
H3 = figure(3);
disp('Ganancia de referencia para el caso general con realimentaci[on por estimación de estados (sacado de Simlukink:)')
set(H3,'menubar','none','position',[50 30 1200 700],...
    'name','Respuesta al Escalón por Controlador Serie de Observación de Estados')
step(M4)
grid