%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% Realimentación y Observación de Estados                                 %
%                                                                         %
% Sistemas de Control. TP Globalizador                                    %
%                                                                         %
% Ejercicio#2 realimentación completa del Vector de Estados               %
%                                                                         %
% Dr. Ing. Franco Martin Pessana                                          %
%                                                                         %
% Facultad Regional Buenos Aires                                          %
% Universidad Tecnológica Nacional                                        %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc

%%% Definición de variables del sistema de posicionamiento %%%
A = 10; % Ganancia del Amplificador Diferencial
La = 100e-3; % Hy
Ra = 2.1; % ohm
Jm = 1.2; % kg.m^2
bm = 6.2; % % N.m.s
Kt = 1; % N.m/a
Kb = 1; % v.s/rad
bv = 30;
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
y_inf = 2; % m

ga = ro*g; % peso específico
Ch = A2/ga;

JT = Jm + Jr + R^2*mp + (R*A1/A2)^2*m;
bT = bm + (R*A1)^2*Rh + (R*A1/A2)^2*bp;
kT = (R*A1)^2/Ch + (R*A1/A2)^2*km;

a0 = Ra*kT/(La*JT);
a1 = (La*kT+Ra*bT+Kb*Kt)/(La*JT);
a2 = (La*bT+Ra*JT)/(La*JT);
b0 = A*A1*R*Kt/(A2*La*JT);

Ap = [0 1 0;
      0 0 1;
     -a0 -a1 -a2];
Bp = [0 0 1]';
Cp = [b0 0 0];
Dp = 0;
disp('Polos de la Planta:')
PGp = eig(Ap)'
[NGp,DGp] = ss2tf(Ap,Bp,Cp,Dp);
disp('Ganancia original de la Planta con Modelo de Estados:')
Gp_ME = tf(NGp,DGp)

disp('Rango Matriz de Controlabilidad:')
MC = ctrb(Ap,Bp);
Rango_MC = rank(MC)
H1=figure(1);
set(H1,'name','Respuesta al escalón de la Planta Original','position',[10 50 1200 650],'menubar','none');
step(Gp_ME,150)
grid
disp('Polos a Lazo cerrado deseados:')
P_LC=[-4+1j*4 -4-1j*4 -20]
disp('Vector de realimentación de Estados traspuesto')
Ke=acker(Ap,Bp,P_LC);
Ke'
disp('Ganancia de la Señal de referencia:')
g0 = y_inf/(Cp*inv(Bp*Ke-Ap)*Bp)
C_DB = eye(3);
D_DB = [0;0;0];
An=Ap-Bp*Ke;
Bn = g0*Bp;
Sys = ss(An,Bn,Cp,Dp);
t = 0:0.01:2;
vr_t = ones(size(t));
[h,t] = lsim(Sys,vr_t,t);
H2=figure(2);
set(H2,'name','Respuesta al escalón con realimentación de Estado','position',[50 50 1200 650],'menubar','none');
plot(t,h)
grid
xlabel('t [s]')
ylabel('h(t) [m]')
disp('Sobrepaso máximo (%):')
Mp = (max(h)-y_inf)/y_inf*100
N = length(t);
k = N;
while(abs(h(k)-y_inf)<=0.02*y_inf)
    k = k-1;
end
disp('Tiempo de asentamiento al 2% (s)')
Ts = t(k)
disp('Transferencia a lazo cerrado nueva:')
[NTLC,DTLC] = ss2tf(An,Bn,Cp,Dp);
TLC = tf(NTLC,DTLC)
disp('Polos a lazo cerrado con realimentación de estado:')
pole(TLC)
disp('Rango Matriz de observabilidad:')
MO = obsv(Ap,Cp);
Rango_MO = rank(MO)
disp('Polos del Estimador')
P_Est = [-12 -12 -12];
Kest = acker(Ap',Cp',P_Est)'

[NGp,DGp] = ss2tf(Ap,Bp,Cp,Dp);
disp('Ganancia de la Planta:')
GP = tf(NGp,DGp)
[NH,DH] = ss2tf(Ap-Kest*Cp-Bp*Ke,Kest,Ke,0);
disp('Ganancia del Comntrolador Observador realimentado:')
H = tf(NH,DH)
disp('Ganancia a lazo cerrado por observación de estados realimentado:')
M1 = feedback(GP,H)
disp('Ganancia de la señal de referencia en la realimentación por por observación de estados')
[NM1,DM1] = tfdata(M1,'v');
NM1F = NM1(length(NM1));
DM1F = DM1(length(DM1));
g00 = DM1F/NM1F