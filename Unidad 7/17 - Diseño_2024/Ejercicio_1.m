%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% Control clásico de sistema de control de posición vertical de automóvil %
%                                                                         %
% Sistemas de Control. TP Globalizador                                    %
%                                                                         %
% Ejercicio#1 Control Clásico                                             %
%                                                                         %
% Dr. Ing. Franco Martin Pessana                                          %
%
% Período Lectivo 2024
%
% Facultad Regional Buenos Aires                                          %
% Universidad Tecnológica Nacional                                        %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc

%%% Definición de variables del sistema de posicionamiento %%%
A = 10; % Ganancia del Amplificador Diferencial
La  = 100e-3; % Hy
Ra = 2.1; % ohm
Jm = 1.2; % kg.m^2
bm = 6.2; % % N.m.s
Kt = 1; % N.m/a
Kb = 1; % v.s/rad
Jr = 1.5; % kg.m^2
R = 0.3; % m
mp = 20; % kg
Rh = 3e3; % Resistencia de la válvula, Ns/m^5
A1 = 1e-2; % m^2
A2 = 1; % m^2
bp = 5; % N.s/m
m = 1200; % kg
km = 20000; % N/m
ro = 1e3; % kg/m^3
kP = 5; % v/m
g = 9.81; % m/s^2

ga = ro*g; % peso específico
Ch = A2/ga;

JT = Jm + Jr + R^2*mp + (R*A1/A2)^2*m;
bT = bm + (R*A1)^2*Rh + (R*A1/A2)^2*bp;
kT = (R*A1)^2/Ch + (R*A1/A2)^2*km;

Jeq = A2*(Jm+Jr)/(R*A1)+R*(mp*A2^2+m*A1^2)/(A1*A2);

Ap=[-Ra/La 0 0 -Kb*A2/(La*R*A1);
0 0 0 A2/Ch;
0 0 0 km;
Kt/Jeq -(R*A1)/Jeq -R*A1/(A2*Jeq) -(A2^2*bm+(R*A1)^2*(A2^2*Rh+bp))/(R*A1*A2*Jeq)];
Bp=[A/La 0 0 0]';
Cp=[0 0 1/km 0];
Dp=0;
disp('Polos de la Planta:')
PGp = eig(Ap)'
[NGp,DGp] = ss2tf(Ap,Bp,Cp,Dp);
disp('Ganancia original de la Planta con Modelo de Estados:')
Gp_ME = tf(NGp,DGp)
disp('Ganancia de la Planta a partir de Diagrama en Bloques con Simulink')
[ApDB,BpDB,CpDB,DpDB] = linmod('Ejercicio_1_Planta_DB_IO');
[NGpVE,DGpVE] = ss2tf(ApDB,BpDB,CpDB,DpDB);
GP_DB = tf(NGpVE,DGpVE)
disp('Ganancia de la Planta analítica:')
NG1 = [Kt/(La*JT) 0];
DG1 = [1 (La*bT+Ra*JT)/(La*JT) (La*kT+Ra*bT+Kb*Kt)/(La*JT) Ra*kT/(La*JT)];
G1 = tf(NG1,DG1);
Gp_A = A*G1*A1*R/A2*tf(1,[1 0])
disp('Altura del auto en el Permanente Analítica con Vr = 1v:')
h_inf = A*A1*R*Kt/(A2*Ra*kT+A*A1*R*Kt*kP)
H1=figure(1);
set(H1,'name','Control Clásico PL 2024. Planta realimentada sin controlar:',...
    'position',[20 20 1000 700],'menubar','none');
disp('Ganancia del sistema a lazo cerrado sin controlar:')
M = feedback(Gp_A,kP)
step(M,150)
grid
disp('Rango de controlabilidad de la Planta:')
R_MC = rank(ctrb(Ap,Bp))
disp('No se puede realimentar con Estados Naturales. Se usa estados Lógicos ')
%%%%%%%%%%%%%%%%%% Control Clásico %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Polos de Gp(s)H(s) antes del Controlador Serie:')
GpH = Gp_A*kP;
[NGpH,DGpH] = tfdata(GpH,'v');
GpH = tf(NGpH(4),DGpH(1:4))
disp('Polos de GpH:')
PGpH = roots(DGpH(1:4))
P_LC = -4 + 1j*4;
disp('Primer cero del controlador PID:')
Z1 = abs(PGpH(3));
Alfa = angle(P_LC - 0)*180/pi
Beta = angle(P_LC - PGpH(2))*180/pi
Gamma = angle(P_LC - PGpH(1))*180/pi 
Delta = Alfa + Beta + Gamma -180
a = imag(P_LC)/tan((180-Delta)*pi/180)
disp('Segundo cero del Controlador:')
Z2 = abs(real(P_LC))-a
Gc = tf(poly([-Z1 -Z2]),[1 0]);
[NGc,DGc] = tfdata(Gc,'v');
H2=figure(2);
set(H2,'NumberTitle','off','Menubar','none',...
    'name','Ejercicio #1. Proyecto Diseño 2024. Bode Gc(s)G(s)H(s)',...
    'position',[40 30 1200 700]);
rlocus(Gc*GpH)
grid
%%%%%% De Rlocus %%%%%%
disp('Constante Derivativa:')
K_D = 350
disp('Constante Proporcional:')
K_P = K_D * NGc(2)
disp('Constante Integral:')
K_I = K_D * NGc(3)
disp('Controlador PID:')
Gc = K_D*Gc
H3=figure(3);
set(H3,'NumberTitle','off','Menubar','none',...
    'name','Ejercicio #1. Proyecto Diseño 2024. Respuesta al Escalón con PID',...
    'position',[60 30 1200 700]);
disp('Ganancia a lazo cerrado:')
VR = 10; % Diferencia de Potencial para tener 2 m
M=feedback(Gc*Gp_A,kP)
step(VR*M)
[NM,DM] = tfdata(M,'v');
disp('Polos a lazo cerrado:')
PLC = roots(DM)
grid

