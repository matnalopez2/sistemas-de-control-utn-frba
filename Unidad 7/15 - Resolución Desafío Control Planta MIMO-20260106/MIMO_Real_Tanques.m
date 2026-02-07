%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Control por Realimentación y estimación de Estados
%%% en Planta MIMO
%%% Se utiliza la pseudoinversa de Moore-Penrose
%%%
%%% Sistemas de COntrol
%%%
%%% Dr. Ing. Franco Pessana
%%% Facultad Regional Buenos Aires
%%% Universidad Tecnológica Nacional
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear
clc

t0 = 0; % Tiempo Inicial de Cálculo
tf1 = 60; % Tiempo final de cálculo de Planta inicial
tfr = 6; % Tiempo final de cálculo con planta Controlada por Estados
At = 1e-3; % Resolución temporal

C1 = 4; % m^2
C2 = 2; % m^2
R1 = 2; % s/m^2
R2 = 1/2; % s/m^2
Q1 = 3; % m^3/s
Q2 = 1; % m^3/s

X0 = [0;0]; % Estados Iniciales

A = [-1/(C1*R1) 1/(R1*C1);1/(C2*R1) -1/C2*(1/R1+1/R2)];
B = [1/C1 0;0 1/C2];
C = [1 0;0 1;0 1/R2];  
D = [0 0;0 0;0 0];

disp('Autovalores de la Planta:')
PG = eig(A)

t1 = t0:At:tf1;
q1 = Q1*ones(size(t1));
q2 = Q2*ones(size(t1));
u1 = [q1;q2]; % Armado vectorial de las entradas

MEP = ss(A,B,C,D); % Modelo de Estados de la Planta
Y = lsim(MEP,u1,t1,X0);

H1 = figure(1);
set(H1,'NumberTitle','off','Menubar','none','name',...
    'Planta Mimo de Tanques para realizar Realimentación del Vector de Estados',...
    'position',[10 30 1200 700]);
subplot(1,2,1)
g = plot(t1,Y(:,1),'r',t1,Y(:,2),'b',t1,Y(:,3),'c');
xlabel('t (s)')
grid
set(g,'linewidth',1.2)
legend('h1(t) [m]','h2(t) [m]','q0(t) [m^3/s]')
title('Sistema sin controlar')

%%%%%%%%%%%%%%%%%% Realimentación de Estados %%%%%%%%%%%%%%%%%%%%%%
disp('Rango de Controlabilidad:')
RC = rank(ctrb(A,B))
disp('Polos a lazo cerrado deseado:')
% Se quiere Polos a lazo cerrado dobles (para que no rebalse en s = -1)
PLC = [-1 -1]'
disp('Matriz de Realimentación de Estados (2x2):')
K = place(A,B,PLC)
disp('Verificación de Polos a lazo cerrado correctos:')
An = A -B*K;
PLC_ver = eig(An)
Y_inf = [8;2;4]; % Vector de salida en el permanente
Q_inf = [3;1]; % Vector de entradas en el permanente
disp('Matriz de Ganancias de Entrada K0')
%%% Cálculo de K0 por fórmulas de Teorema del Valor Final
% K0 = pinv(C*inv(B*K-A)*B)*Y_inf*pinv(Q_inf)
%%% Cálculo de K0 por Fórmula de Teorema de Valor Final pero con ganancias
K0 = pinv(dcgain(ss(An,B,C,D)))*Y_inf*pinv(Q_inf)
ME_Real = ss(An,B*K0,C,D);
tr = t0:At:tfr;
q1r = Q1*ones(size(tr));
q2r = Q2*ones(size(tr));
ur = [q1r;q2r];
Y_R = lsim(ME_Real,ur,tr,X0);

subplot(1,2,2)
g = plot(tr,Y_R(:,1),'r',tr,Y_R(:,2),'b',tr,Y_R(:,3),'c');
xlabel('t (s)')
grid
set(g,'linewidth',1.2)
legend('h1(t) [m]','h2(t) [m]','q0(t) [m^3/s]')
title('Sistema Controlado por realimentación de estados')

%%%%%%%%%%%%%%%%%% Estimación de Estados %%%%%%%%%%%%%%%%%%%%%%
disp('Rango Matriz de Observabilidad:')
R_MO = rank(obsv(A,C))
disp('Polos del Estimador:')    
PEE = [-3.5 -4]
disp('Vector de Estimación de Estados:')
Ke = place(A',C',PEE)'
%%% Estimador como H(s) para Caso#4
Ae = A - Ke*C - B*K;
disp('Polos del Estimador como Realmimentador en Caso#4:')
PHest = eig(Ae)
Be = Ke;
Ce = K;
De = [0 0 0;0 0 0];
Hest =ss(Ae,Be,Ce,De);
M00 = feedback(MEP,Hest);
disp('Ganancia de referencia para conseguir h1_inf=8m, h2_inf=2m y q0_inf=4 m^3/s')
K00 = pinv(dcgain(M00))*Y_inf*pinv(Q_inf)



