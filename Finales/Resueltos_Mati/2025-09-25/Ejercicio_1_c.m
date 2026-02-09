% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Ejercicio X 
% Realizado por: Matías Nahuel López
% 
% Universidad Tecnológica Nacional
% Facultad Regional de Buenos Aires
% 
% Legajo: 153.327-7
% Contacto: matias@matnalopez.com.ar
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Inicialización

% Generales
clear; clc; close all;
s = tf('s');

% Para gráficos
T_inicio    = 0;
delta_t     = 0.01;
T_final     = 8;
t           = (T_inicio:delta_t:T_final)';


%% Datos del problema

R1  = 1000;         % R1  = 1k ohm
R2  = 1000;         % R2  = 1k ohm
R4  = 2000;         % R4  = 2k ohm
R6a = 1000;         % R6a = 1k ohm
R6b = 1000;         % R6b = 1k ohm
C3  = 10 * 10^-6;   % C3  = 10 uF
C5  = 10 * 10^-6;   % C5  = 10 uF

G1  = 1/R1;
G2  = 1/R2;
G4  = 1/R4;
G6a = 1/R6a;
G6b = 1/R6b;

numM = [(G1+G2) * G4 * G6a];
% denM1 = C5*C3*G1
% denM2 = G2*G4*(G6a+G6b)
denM = [C5*C3*G1 0 G2*G4*(G6a+G6b)];

M = tf(numM, denM)

%% Resolución

%% Ejercicio 1
polos = pole(M)
% figure;bode(M); grid on
% figure;step(M); grid on
% figure;pzmap(M); grid on

%% Ejercicio 2

% margin(M)

[A_ss, B_ss, C_ss, D_ss] = utilsMati.generales.tf2ss_mati(numM,denM);


disp("Analizo si es controlable y observable")
utilsMati.realim_VE.esControlable(A_ss,B_ss);
utilsMati.realim_VE.esObservable(A_ss,C_ss);

PLC = [-100 -500];
K_ss = acker(A_ss,B_ss,PLC)

An = A_ss - B_ss*K_ss

PLC_d = eig(An)


%Ahora, para seguir el escalon con error nulo
g0=1/(C_ss*inv(-A_ss+B_ss*K_ss)*B_ss)

%Rearmo mi sistema compensado

sys = ss(An, B_ss*g0, C_ss, D_ss);

G2 = tf(sys)

F3=figure(3);
step(G2);
stepinfo(G2)
grid on;





