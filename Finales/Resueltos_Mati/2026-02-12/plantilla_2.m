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


m = 48;
bm = 0;
b1 = 250/3;
k1 = 1000;
k2 = 200;

A = [-k1/b1 0 1; 0 0 1; -k1/m -k2/m -bm/m]
B = [ k1/b1 0 (k1+k2)/m]';
C = [0 1 0];
D = 0;


%% Resolución


PLC = [-4+4i -4-4i -20];

K = acker(A,B,PLC)
An = A - B*K
PLC_d = eig(An)

g0 = 1/(C*inv(-A+B*K)*B)


sys = ss(An, B*g0, C, D);
step(sys)
stepinfo(sys)